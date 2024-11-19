# 编译器和编译选项
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -g \
           -Wno-sign-compare \
           -fpermissive \
           -Wno-unused-parameter

# 头文件路径
INCLUDES = -I src/graphdb/ \
           -I src/common/ \
           -I src/util/ \
           -I third_party/cpp-httplib \
           -I third_party/googletest/googletest/include \
           -I third_party/spdlog/include \
           -I third_party/nlohmann_json/include \
           -I third_party/leveldb/include \
           -I third_party/cxxopts/include

# 静态库路径和链接选项
LDFLAGS = -L third_party/googletest/build/lib \
          -L third_party/spdlog/build \
          -L third_party/leveldb/build
LDLIBS = -lgtest -lgtest_main -lspdlog -lleveldb -pthread -ldl

# 目录定义
SRC_DIR = src
TEST_DIR = $(SRC_DIR)/test
MAIN_DIR = $(SRC_DIR)/main
OUTPUT_DIR = output
TEST_OUTPUT_DIR = $(OUTPUT_DIR)/test
MAIN_OUTPUT_DIR = $(OUTPUT_DIR)/main
OBJ_DIR = $(OUTPUT_DIR)/obj
COVERAGE_DIR = $(OUTPUT_DIR)/coverage

# 为coverage添加额外的编译选项
COVERAGE_FLAGS = --coverage
COVERAGE_LDFLAGS = -lgcov

# 源文件
TEST_SRCS = $(wildcard $(TEST_DIR)/*.cc)
TEST_OBJS = $(TEST_SRCS:$(TEST_DIR)/%.cc=$(OBJ_DIR)/test/%.o)
TEST_BINS = $(TEST_SRCS:$(TEST_DIR)/%.cc=$(TEST_OUTPUT_DIR)/%)

MAIN_SRCS = $(wildcard $(MAIN_DIR)/*.cc)
MAIN_OBJS = $(MAIN_SRCS:$(MAIN_DIR)/%.cc=$(OBJ_DIR)/main/%.o)
MAIN_BINS = $(MAIN_SRCS:$(MAIN_DIR)/%.cc=$(MAIN_OUTPUT_DIR)/%)

UTIL_SRCS = $(wildcard $(SRC_DIR)/util/*.cc)
UTIL_OBJS = $(UTIL_SRCS:$(SRC_DIR)/util/%.cc=$(OBJ_DIR)/util/%.o)

GRAPHDB_SRCS = $(wildcard $(SRC_DIR)/graphdb/*.cc)
GRAPHDB_OBJS = $(GRAPHDB_SRCS:$(SRC_DIR)/graphdb/%.cc=$(OBJ_DIR)/graphdb/%.o)

# ASAN支持
ifeq ($(ASAN),yes)
CXXFLAGS += -fsanitize=address -fno-omit-frame-pointer
LDFLAGS += -fsanitize=address
endif

# coverage支持
ifeq ($(COVERAGE),yes)
CXXFLAGS += $(COVERAGE_FLAGS)
LDFLAGS += $(COVERAGE_LDFLAGS)
endif

# 默认目标
all: test main

# 创建输出目录
$(shell mkdir -p $(OUTPUT_DIR) $(TEST_OUTPUT_DIR) $(MAIN_OUTPUT_DIR) $(OBJ_DIR)/test $(OBJ_DIR)/util $(OBJ_DIR)/graphdb $(OBJ_DIR)/main $(COVERAGE_DIR))

# 编译规则
$(OBJ_DIR)/test/%.o: $(TEST_DIR)/%.cc
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/main/%.o: $(MAIN_DIR)/%.cc
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/util/%.o: $(SRC_DIR)/util/%.cc
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/graphdb/%.o: $(SRC_DIR)/graphdb/%.cc
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# 链接测试程序
$(TEST_OUTPUT_DIR)/%: $(OBJ_DIR)/test/%.o $(UTIL_OBJS) $(GRAPHDB_OBJS)
	$(CXX) $^ $(LDFLAGS) $(LDLIBS) -o $@

# 链接主程序
$(MAIN_OUTPUT_DIR)/%: $(OBJ_DIR)/main/%.o $(UTIL_OBJS) $(GRAPHDB_OBJS)
	$(CXX) $^ $(LDFLAGS) $(LDLIBS) -o $@

# 编译测试程序
test: $(TEST_BINS)

# 编译主程序
main: $(MAIN_BINS)

# 运行测试
runtest: test
	for test in $(TEST_BINS) ; do ./$$test ; done

# 生成覆盖率报告
coverage:
	$(MAKE) clean
	$(MAKE) COVERAGE=yes test
	@echo "Running tests with coverage..."
	@for test in $(TEST_BINS); do \
		./$$test || exit 1; \
	done
	@echo "Generating coverage report..."
	lcov --capture --directory . --output-file $(COVERAGE_DIR)/coverage.info
	lcov --remove $(COVERAGE_DIR)/coverage.info '/usr/*' '*/third_party/*' '*/test/*' --output-file $(COVERAGE_DIR)/coverage.info
	genhtml $(COVERAGE_DIR)/coverage.info --output-directory $(COVERAGE_DIR)
	@echo "Coverage report generated in $(COVERAGE_DIR)"

# 格式化代码
format:
	find src -name "*.h" -o -name "*.cc" | xargs clang-format -i -style=google

# 清理
clean:
	rm -rf $(OUTPUT_DIR)
	find . -name "*.gcda" -o -name "*.gcno" -o -name "*.gcov" | xargs rm -f 2>/dev/null || true

.PHONY: all test main runtest coverage format clean
