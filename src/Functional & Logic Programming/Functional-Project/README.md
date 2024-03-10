# PFL-Project
* Practical class: 3LEIC01
* Group: T01_G13
* Students:
    - Veronica Ramirez Marin (up202301350)
	- Antonio Augusto Brito de Sousa
	- Vlad Ryan Plavosin (up202301426)
	
## Descrition of First Part

#### Data Definition
Our program makes use of four different data structures:
	- *StackElem* is defined as either a boolean or an integer type. This is the data type that will be used throughout to represent all stack elements as well as the values associated to the variables stored in state. We define it this way since both integer and boolean values are required for our program.
	- *Stack* is a list containing elements of the previously defined type. This, as the name implies, will be used to hold the elements of the stack, the first element in the list being the top of the stack.
	- *VarValue* has been defined as a tuple, the first element being a string and the second one a *StackElem*. This represents a pair where the first value will be the name of the variable we want to store and the second one will be a value, which in this case can also be either an integer or a boolean.
	- *State* is the type used to keep track of the state of the program. It is defined as a list of the type *VarValue* and remembers all added variables, by their name and value,

#### Function Declaration
The functions we have are split into two main parts, we will first take a look at the functions used to initialize the program, as well as those used to print the values to the console:
	- *createEmptyStack* and *createEmptyState* are used when the program is first run, each one of them simply returning a new empty list in which elements of their respective types will be stored.
	- *stack2Str* and *state2Str* are the functions used to print everything and are also quite similar one to the other. These functions concatenate all the values in the stack and string and make use of the function *intercalate* from the library *Data.List* to add a come between each value. A difference between the two is that when printing the state, it is printed as "name = value" and the function *sort* is used to have it be in the correct order.
	
The second part of the program is contained within the run function. Here we have all the functionalities of the instructions. The function is recursive and will run until its base case, which is when the instruction list is empty as all the instructions have been executed.
The function decides which instructions to execute by taking it from the top of the execution stack as such: (Add):rest, (Equ):rest etc. For all of the simpler instructions, The function simply takes the first one or two elements as needed from the stack, then calling the run function again with only the rest of the instructions and the required value added to the top of the stack. It is also worth mentioning that because of the use of the either in the declaration of the elements, whenever values are used they are called such as "Right y" or Left (x==y).
Now let us take a look at the non-arithmetic functions:
	- *Push n*, *Tru* and *Fals* are also quite simple, as they just add to the stack the specified element, similar to the arithmetic operations but without removing anything.
	- *Branch c1 c2* uses an if/else statement to check the top of the stack and then calls run again with the corresponding instruction added to the top of the instructions list.
	- *Noop* simply calls the run function, removing itself from the list.
	- *Loop c1 c2* also just calls the run function again, however the first parameter is added to the stack and if the second one is evaluated as true, the initial instruction is called again.
	- *Fetch var* makes use of case/of to check whether the variable exists. If it does, its value is pushed to the top of the stack,otherwise an error is thrown.
	- *Store var* is similar to *Fetch var* but it is used to add the value add the top of the stack to the state, with the desired name. an auxilliary function "updateState :: String -> StackElem -> State -> State" is used to check whether the value already exists inside the state or not. The function checks recursively to see if the variable name is already in use and if it is it changes its value, otherwise it simply adds a new one.
	
## Descrition of Second Part
#### Data definiction
Three new types of data structures have been defined:
- Aexp: in which Addi, Subs, Mul and Var and Const are defined.
- Bexp: in which Tr and Fal are defined as true and false, Eqb for the equivalence between Boolean expressions, Eq for the equivalence between arithmetic expressions, Negi and Leq.
- Stm: in which Assign, Seq, If and While are defined.
#### Compiler definition
For this small imperative program, compiler has been built, whose main function is to translate the program language to the low-level machine language. This translation is done with the help of two auxiliary compilers, compA for arithmetic operations and compB for Boolean operations. The compiler will be in charge of translating the operations previously defined as Stm