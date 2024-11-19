let simulation;
let svg;
let width;
let height;
let nodes = [];
let links = [];

// 初始化D3力导向图
function initGraph() {
    const container = document.querySelector('.graph-container');
    width = container.clientWidth;
    height = container.clientHeight;

    svg = d3.select('#graph')
        .attr('width', width)
        .attr('height', height);

    simulation = d3.forceSimulation()
        .force('link', d3.forceLink().id(d => d.id))
        .force('charge', d3.forceManyBody().strength(-300))
        .force('center', d3.forceCenter(width / 2, height / 2));
}

// 更新图形
function updateGraph(data) {
    // 清除现有的图形
    svg.selectAll('*').remove();

    // 创建箭头标记
    svg.append('defs').append('marker')
        .attr('id', 'arrowhead')
        .attr('viewBox', '-0 -5 10 10')
        .attr('refX', 20)
        .attr('refY', 0)
        .attr('orient', 'auto')
        .attr('markerWidth', 6)
        .attr('markerHeight', 6)
        .append('path')
        .attr('d', 'M0,-5L10,0L0,5')
        .attr('fill', '#999');

    // 创建边
    const link = svg.append('g')
        .selectAll('line')
        .data(data.links)
        .enter().append('line')
        .attr('class', 'link')
        .attr('marker-end', 'url(#arrowhead)')
        .attr('stroke-width', d => Math.sqrt(d.weight));

    // 创建节点组
    const node = svg.append('g')
        .selectAll('.node')
        .data(data.nodes)
        .enter().append('g')
        .attr('class', 'node')
        .call(d3.drag()
            .on('start', dragstarted)
            .on('drag', dragged)
            .on('end', dragended));

    // 添加节点圆圈
    node.append('circle')
        .attr('r', 10)
        .attr('fill', '#69b3a2');

    // 添加节点文本标签
    node.append('text')
        .attr('dx', 12)
        .attr('dy', '.35em')
        .text(d => d.properties.name);

    // 更新模拟器
    simulation
        .nodes(data.nodes)
        .on('tick', ticked);

    simulation.force('link')
        .links(data.links);

    // 定义tick行为
    function ticked() {
        link
            .attr('x1', d => d.source.x)
            .attr('y1', d => d.source.y)
            .attr('x2', d => d.target.x)
            .attr('y2', d => d.target.y);

        node
            .attr('transform', d => `translate(${d.x},${d.y})`);
    }
}

// 拖拽行为函数
function dragstarted(event) {
    if (!event.active) simulation.alphaTarget(0.3).restart();
    event.subject.fx = event.subject.x;
    event.subject.fy = event.subject.y;
}

function dragged(event) {
    event.subject.fx = event.x;
    event.subject.fy = event.y;
}

function dragended(event) {
    if (!event.active) simulation.alphaTarget(0);
    event.subject.fx = null;
    event.subject.fy = null;
}

// 加载图数据
async function loadGraph() {
    try {
        const response = await fetch('/api/graph');
        const data = await response.json();
        
        // 转换数据格式以适应D3
        const nodes = data.nodes;
        const links = data.edges.map(edge => ({
            source: edge.from,
            target: edge.to,
            weight: edge.properties.weight || 1
        }));

        updateGraph({ nodes, links });
    } catch (error) {
        console.error('加载图数据失败:', error);
    }
}

// 表单提交处理函数
document.getElementById('nodeForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const nodeData = {
        id: parseInt(document.getElementById('nodeId').value),
        properties: {
            name: document.getElementById('nodeName').value
        }
    };

    try {
        await fetch('/api/node', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(nodeData)
        });
        loadGraph();
    } catch (error) {
        console.error('添加节点失败:', error);
    }
});

document.getElementById('edgeForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const edgeData = {
        from: parseInt(document.getElementById('fromNode').value),
        to: parseInt(document.getElementById('toNode').value),
        weight: parseFloat(document.getElementById('weight').value),
        properties: {
            type: document.getElementById('edgeType').value
        }
    };

    try {
        await fetch('/api/edge', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(edgeData)
        });
        loadGraph();
    } catch (error) {
        console.error('添加边失败:', error);
    }
});

document.getElementById('pathForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const fromId = document.getElementById('pathFrom').value;
    const toId = document.getElementById('pathTo').value;

    try {
        const response = await fetch(`/api/shortest_path/${fromId}/${toId}`);
        const path = await response.json();
        // 高亮显示最短路径
        highlightPath(path.nodes);
    } catch (error) {
        console.error('查找最短路径失败:', error);
    }
});

// 初始化
window.addEventListener('load', () => {
    initGraph();
    loadGraph();
});

// 窗口大小改变时重新计算图形大小
window.addEventListener('resize', () => {
    width = document.querySelector('.graph-container').clientWidth;
    height = document.querySelector('.graph-container').clientHeight;
    svg.attr('width', width).attr('height', height);
    simulation.force('center', d3.forceCenter(width / 2, height / 2));
    simulation.restart();
}); 