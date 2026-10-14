CXX       := g++
CXXFLAGS  := -std=c++23 -Wall -Wextra -Wpedantic -g -MMD -MP
CPPFLAGS  :=
LDFLAGS   :=
LDLIBS    :=

TARGET    := main

SRCS      := $(wildcard *.cpp)
OBJS      := $(SRCS:.cpp=.o)
DEPS      := $(OBJS:.o=.d)

ifeq ($(OS),Windows_NT)
    EXE   := $(TARGET).exe
    RUN   := .\$(EXE)
    CLEAN := del /Q /F $(OBJS) $(DEPS) $(EXE) 2>NUL
else
    EXE   := $(TARGET)
    RUN   := ./$(EXE)
    CLEAN := rm -f $(OBJS) $(DEPS) $(EXE)
endif

.DEFAULT_GOAL := all

.PHONY: all run clean

all: $(EXE)

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) $(OBJS) $(LDLIBS) -o $@

%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

run: $(EXE)
	$(RUN)

clean:
	-$(CLEAN)

-include $(DEPS)
