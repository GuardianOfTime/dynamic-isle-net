# DynamicIsleNet - build and test
CXX      = g++
CXXFLAGS = -std=c++17 -O2
TARGET   = solver
SRC      = src/main.cpp

.PHONY: all build test clean

all: build

build: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $@ $<
	@echo "Build succeeded: ./$(TARGET)"

test: $(TARGET)
	@./scripts/run_tests.sh

clean:
	rm -f $(TARGET) $(TARGET).exe
