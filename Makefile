include EditMe
ICONCERT=/opt/ibm/ILOG/CPLEX_Studio_Community128/concert/include
ICPLEX=/opt/ibm/ILOG/CPLEX_Studio_Community128/cplex/include
INUPACK=/usr/local/include/nupack
IEIGEN=/usr/local/include/eigen3
LCONCERT=/opt/ibm/ILOG/CPLEX_Studio_Community128/concert/lib/x86-64_linux/static_pic/
LCPLEX=/opt/ibm/ILOG/CPLEX_Studio_Community128/cplex/lib/x86-64_linux/static_pic/

# project name (generate executable with this name)
TARGET   = biorseo

CC	   = clang++
# compiling flags here
CFLAGS   = -Icppsrc/ -I/usr/local/include -I$(ICONCERT) -I$(ICPLEX) -I$(INUPACK) -I$(IEIGEN) -O3
CXXFLAGS = --std=c++17 -Wall -Wpedantic -Wextra -Wno-ignored-attributes -Wno-unused-variable

LINKER   = clang++
# linking flags here
LDFLAGS   = -L$(LCONCERT) -L$(LCPLEX) -lboost_system -lboost_filesystem -lboost_program_options -lconcert -lilocplex -lcplex -lpthread -ldl -lnupackpfunc -lnupackutils

# change these to proper directories where each file should be
SRCDIR   = cppsrc
OBJDIR   = obj
BINDIR   = bin

SOURCES  := $(wildcard $(SRCDIR)/*.cpp)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
rm	   = rm -f

$(BINDIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(BINDIR)
	$(LINKER) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "\033[00;32mLinking completed.\033[00m"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(INCLUDES)
	@mkdir -p $(OBJDIR)
	$(CC) -c $(CFLAGS) $(CXXFLAGS) $< -o $@
	@echo "\033[00;32mCompiled "$<".\033[00m"

.PHONY: all
all: $(BINDIR)/$(TARGET)

.PHONY: re
re: remove clean all

.PHONY: clean
clean:
	$(rm) $(OBJECTS)
	@echo "\033[00;32mCleanup completed.\033[00m"

.PHONY: remove
remove: clean
	@$(rm) $(BINDIR)/$(TARGET)
	@echo "\033[00;32mExecutable removed!\033[00m"
