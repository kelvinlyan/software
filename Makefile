SRC := src
INC := include
BIN := bin
OBJ := obj

srcs = $(wildcard $(SRC)/*.cpp)
objs = $(patsubst %.cpp, $(OBJ)/%.o, $(notdir $(srcs)))
deps = $(objs:%.o=%.d)

TARGET := main

CC := g++
CCFLAGS := -I$(INC)

vpath %.h $(INC)
vpath %.cpp $(SRC)

all : dep $(BIN)/$(TARGET)

dep :
$(OBJ)/%.d : $(SRC)/%.cpp
	@set -e;
	@rm -f $@;
	@$(CC) -MM $< $(CCFLAGS) > $@.temp;
	@sed 's,\($*\)\.o[ :]*,$(OBJ)/\1.d : ,g' < $@.temp >> $@;
	@sed 's,\($*\)\.o[ :]*,$(OBJ)/\1.o : ,g' < $@.temp >> $@;
	@echo -e "\t"$(CC) -c $< -o $(subst .d,.o,$@) $(CCFLAGS) >> $@;
	@rm -f $@.temp;

$(BIN)/$(TARGET) : $(objs)
	$(CC) -o $(BIN)/$(TARGET) $^;

include $(deps)

.PHONY : info
info :
	@echo $(srcs);
	@echo $(objs);
	@echo $(deps);

.PHONY : clean
clean :
	-rm -rf $(OBJ)/* $(BIN)/$(TARGET);

	
