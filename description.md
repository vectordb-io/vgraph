# 图数据库

## Overview
- 项目名称: vgraph
- 项目实现了图数据库的存储引擎
- 使用leveldb作为存储引擎
- 使用http协议提供接口
- 使用C++17编写

## Directory Structure
```
.
├── description.md
├── LICENSE
├── Makefile
├── README_CN.md
├── README.md
├── src
│   ├── common
│   │   ├── common.h
│   │   └── slice.h
│   ├── graphdb
│   │   ├── graphdb.cc
│   │   └── graphdb.h
│   ├── main
│   │   └── vgraph_server.cc
│   ├── test
│   │   ├── coding_demo_test.cc
│   │   ├── coding_test.cc
│   │   └── graphdb_test.cc
│   └── util
│       ├── coding.cc
│       ├── coding_demo.cc
│       ├── coding_demo.h
│       └── coding.h
├── third_party
│   ├── cpp-httplib
│   ├── cxxopts
│   ├── googletest
│   ├── leveldb
│   ├── nlohmann_json
│   └── spdlog
└── web
```

## Directory Description
- `src/common`: 公共头文件目录
- `src/graphdb`: 图存储引擎实现源码目录
- `src/main`: 包含main函数的源码目录
- `src/test`: 测试用例源码目录
- `src/util`: 工具类目录
- `output/test`: 测试的可执行程序目录
- `output/coverage`: 覆盖率测试结果目录
- `output/obj`: 编译生成的中间文件目录
- `output/main`: 编译生成的可执行程序目录
- `third_party`: 第三方库目录
- `web`: 用户交互页面目录

## File Description
- `common.h`: 公共头文件
- `slice.h`: 字符串切片类
- `vgraph_server.cc`: 主函数
- `graphdb.h`: 图存储引擎类 
- `graphdb.cc`: 图存储引擎类的实现
- `coding.cc`: 编码相关函数的实现
- `coding.h`: 编码相关函数的声明
- `coding_demo.cc`: 编码函数如何使用的样例代码
- `coding_demo.h`: 编码函数如何使用的样例代码的声明
- `coding_demo_test.cc`: 关于coding_demo.h中相关类与函数的测试用例
- `coding_test.cc`: 关于coding.h中相关类与函数的测试用例
- `graphdb_test.cc`: 关于graphdb.h中相关类与函数的测试用例
- `Makefile`: 构建自动化脚本
- `README.md`: 项目文档和使用说明（英文）
- `README_CN.md`: 项目文档和使用说明（中文）


## 用户交互页面功能
- 使用html,css,javascript,python3,flask实现
- 启动方式 `python app.py`，在`127.0.0.1:5000`端口提供http服务
- 用户使用浏览器访问`127.0.0.1:5000`，通过点击页面上的按钮来操作
- 功能包括：
    - 添加节点
    - 添加边
    - 查找最短路径
    - 可视化的方式展示图数据库中的节点与边
- app.py调用c++程序vgraph_server提供的http接口(http://127.0.0.1:8080)，实现对图数据库的增删改查。命令格式参考“使用curl命令测试”章节


## 使用curl命令测试

### 添加节点 (1-20)
```bash
# 添加节点1-5 (城市)
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 1, "properties": {"name": "北京"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 2, "properties": {"name": "上海"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 3, "properties": {"name": "广州"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 4, "properties": {"name": "深圳"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 5, "properties": {"name": "杭州"}}'

# 添加节点6-10 (景点)
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 6, "properties": {"name": "故宫"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 7, "properties": {"name": "外滩"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 8, "properties": {"name": "西湖"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 9, "properties": {"name": "珠峰塔"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 10, "properties": {"name": "世界之窗"}}'

# 添加节点11-15 (餐厅)
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 11, "properties": {"name": "全聚德"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 12, "properties": {"name": "南翔小笼"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 13, "properties": {"name": "陶然居"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 14, "properties": {"name": "绿茶餐厅"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 15, "properties": {"name": "顺记冰室"}}'

# 添加节点16-20 (酒店)
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 16, "properties": {"name": "北京饭店"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 17, "properties": {"name": "和平饭店"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 18, "properties": {"name": "白天鹅宾馆"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 19, "properties": {"name": "深圳华侨城"}}'
curl -X POST http://127.0.0.1:8080/node -H "Content-Type: application/json" -d '{"id": 20, "properties": {"name": "西子湖四季"}}'
```

### 添加边 (城市之间的交通连接)
```bash
# 城市之间的高铁连接
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 1, "to": 2, "weight": 4.5, "properties": {"type": "高铁"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 2, "to": 5, "weight": 2.5, "properties": {"type": "高铁"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 2, "to": 3, "weight": 8.0, "properties": {"type": "高铁"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 3, "to": 4, "weight": 1.0, "properties": {"type": "高铁"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 5, "to": 3, "weight": 6.0, "properties": {"type": "高铁"}}'
```

### 添加边 (城市与景点的连接)
```bash
# 城市与景点的连接
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 1, "to": 6, "weight": 1.0, "properties": {"type": "景点"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 2, "to": 7, "weight": 1.0, "properties": {"type": "景点"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 5, "to": 8, "weight": 1.0, "properties": {"type": "景点"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 3, "to": 9, "weight": 1.0, "properties": {"type": "景点"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 4, "to": 10, "weight": 1.0, "properties": {"type": "景点"}}'
```

### 添加边 (城市与餐厅的连接)
```bash
# 城市与餐厅的连接
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 1, "to": 11, "weight": 1.0, "properties": {"type": "餐厅"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 2, "to": 12, "weight": 1.0, "properties": {"type": "餐厅"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 3, "to": 13, "weight": 1.0, "properties": {"type": "餐厅"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 5, "to": 14, "weight": 1.0, "properties": {"type": "餐厅"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 4, "to": 15, "weight": 1.0, "properties": {"type": "餐厅"}}'
```

### 添加边 (城市与酒店的连接)
```bash
# 城市与酒店的连接
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 1, "to": 16, "weight": 1.0, "properties": {"type": "酒店"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 2, "to": 17, "weight": 1.0, "properties": {"type": "酒店"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 3, "to": 18, "weight": 1.0, "properties": {"type": "酒店"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 4, "to": 19, "weight": 1.0, "properties": {"type": "酒店"}}'
curl -X POST http://127.0.0.1:8080/edge -H "Content-Type: application/json" -d '{"from": 5, "to": 20, "weight": 1.0, "properties": {"type": "酒店"}}'
```

### 测试最短路径查询
```bash
# 查询从北京到深圳的最短路径
curl http://127.0.0.1:8080/shortest_path/1/4

# 查询从杭州到广州的最短路径
curl http://127.0.0.1:8080/shortest_path/5/3
```

### 查看整个图的数据
```bash
# 获取完整的图数据
curl http://127.0.0.1:8080/graph
```

这些命令创建了一个包含:
- 5个城市节点 (1-5)
- 5个景点节点 (6-10)
- 5个餐厅节点 (11-15)
- 5个酒店节点 (16-20)
- 城市之间的高铁连接
- 城市与景点的连接
- 城市与餐厅的连接
- 城市与酒店的连接

形成了一个模拟的旅游信息图数据库。

## Coding Guidelines
- Follow the Google C++ Style Guide (https://google.github.io/styleguide/cppguide.html), which has already been added into cursor's Docs(@google_cppstyle).
- Use modern C++11/14/17 features whenever possible.
- Make sure to handle errors and edge cases gracefully.
- Add comments in English in every class, function, and important block of code.
- Keep functions small and focused (single responsibility).
- Ensure code is clean and readable.
- Use .cc extension for C++ source files and .h extension for header files.

## 注释的格式
- 类注释样例
```
/**
 * @brief 日志类，封装spdlog库实现日志功能
 * 
 * 功能特性:
 * - 支持日志分级 (trace, debug, info, warn, error, critical)
 * - 支持同步/异步写入
 * - 支持输出到控制台
 * - 支持输出到文件
 * - 支持输出到滚动文件
 */
```

- 函数注释样例
```
  /**
   * @brief 初始化滚动文件日志
   * @param filename 日志文件名
   * @param max_file_size 单个日志文件最大大小
   * @param max_files 最大日志文件数量
   * @param level 日志级别
   * @param async 是否异步写入
   */
  void InitRotatingLogger(const std::string& filename,
                         size_t max_file_size,
                         size_t max_files,
                         spdlog::level::level_enum level = spdlog::level::info,
                         bool async = false);
```

## Rules For Coding
- 项目使用`namespace vgraph`

## Third-Party Libraries

### third_party/googletest
- version: 1.14.0
- description: Google Test is a C++ testing framework.
- include path: `third_party/googletest/googletest/include`
- static library path: 
    - `third_party/googletest/build/lib/libgtest.a`
    - `third_party/googletest/build/lib/libgtest_main.a`

### third_party/cpp-httplib
- description: A C++ header-only HTTP library.
- include path: `third_party/cpp-httplib`

### third_party/spdlog
- version: v1.13.0
- description: Fast C++ logging library.
- include path: `third_party/spdlog/include/`
- static library path: 
    - `third_party/spdlog/build/libspdlog.a`

### third_party/nlohmann_json
- version: v3.10.0
- description: JSON for Modern C++.
- include path: `third_party/nlohmann_json/include/`

### third_party/leveldb
- version: 1.22
- description: LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.
- include path: `third_party/leveldb/include/`
- static library path: 
    - `third_party/leveldb/build/libleveldb.a`

### third_party/cxxopts
- version: v3.2.0
- description: Lightweight C++ option parser library.
- include path: `third_party/cxxopts/include/`

## Rules For Makefile
- 将目录 `src/test/` 下的每个.cc文件与其对应的源文件编译并链接成可执行文件. 例如: 将 `coding_test.cc` 与 `coding.cc` 编译链接成可执行文件 `coding_test`.
- 生成的可执行测试程序存放在目录 `output/test/` 中, 例如: 将 `coding_test` 存放在 `output/test/` 中.
- 将目录 `src/main/` 下的 `vgraph_server.cc` 文件与`src/graphdb/`, `src/common`, `src/util/` 下的所有文件编译链接成可执行文件 `vgraph_server`
- 生成的可执行文件存放在目录 `output/main/` 中, 例如: 将 `vgraph_server` 存放在 `output/main/` 中.
- 编译时需要添加如下头文件路径的参数:
    - `-I src/graphdb/`
    - `-I src/common/`
    - `-I src/util/`
    - `-I third_party/cpp-httplib`
    - `-I third_party/googletest/googletest/include`
    - `-I third_party/spdlog/include`
    - `-I third_party/nlohmann_json/include`
    - `-I third_party/leveldb/include`
    - `-I third_party/cxxopts/include`
- 编译时需要静态链接第三方库:
    - `third_party/googletest`
    - `third_party/spdlog`
    - `third_party/nlohmann_json`
    - `third_party/leveldb`
    - `third_party/cxxopts`
- 编译时需要添加 `-pthread -ldl` 参数.
- Makefile中包含命令如下:
    - `make test`命令. 编译 `src/test/` 下的所有测试程序.
    - `make runtest`命令. 运行 `output/test/` 下的所有测试程序.
    - `make main`命令. 编译 `src/main/` 下的所有可执行文件.
    - `make coverage`命令. 使用lcov，gcov工具，为测试程序生成测试覆盖率报告. 
        -生成的覆盖率信息与index.html存放在`output/coverage`目录中.
    - `make clean`命令. 清除生成的中间文件, 可执行文件, 测试覆盖率报告等.
    - `make format`命令. 使用clang-format工具将src目录下的所有的.h和.cc文件格式化成google style.
    - 为Makefile添加`ASAN`参数, `ASAN=yes`时，使用`ASAN`工具检查内存错误.默认`ASAN=no`.
- 根据以上规则生成 Makefile 内容

## Example Output

## License

This project is open source and available under the MIT License.


