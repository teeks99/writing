Title:  "C++ Enums"
Date:   2019-02-13 22:00:00 -0600

Using Enumerations in C++
=========================

The problem
-----------
In olden times, C++ enums were the same as C enums. That is they had global scope for the names created:

```C++
#include <iostream>

enum SIM_MODE
{
   INITIALIZE = 1,
   RUN = 2,
   RESET = 3,
   PAUSE = 4
};

enum CONTROL
{
   START = 1,
   STOP = 2,
   PAUSE = 3
};

int main(int argc, char* argv[])
{
   SIM_MODE mode = INITIALIZE;
   CONTROL control = START;

   //... time passes

   control = PAUSE;

   std::cout << control << std::endl;

   return 0;
}
```

Gives an error:
`main.cpp(16): error C2365: 'PAUSE': redefinition; previous definition was 'enumerator'`

This is because all the names decleared in the enum are global.

C code solves this problem by making the names more specific, e.g. CONTROL_START, CONTROL_STOP, CONTROL_PAUSE. This can
get out of hand quite quickly. Yuck!

C++ Enums
---------

In C++ (98/03) we solved this by adding namespaces around the enums (). This solves the problem, but has some redundancy:

```C++
namespace SimMode
{
   enum SIM_MODE
   {
      INITIALIZE = 1,
      RUN = 2,
      RESET = 3,
      PAUSE = 4
   };
};

namespace Control
{
   enum CONTROL
   {
      START = 1,
      STOP = 2,
      PAUSE = 3
   };
};

int main(int argc, char* argv[])
{
   SimMode::SIM_MODE mode = SimMode::INITIALIZE;
   Control::CONTROL control = Control::START;

   //... time passes

   control = Control::PAUSE;

   std::cout << control << std::endl;
   // Correctly outputs: 3

   return 0;
}
```

This could also have been put in a class/struct instead of a namespace. Useful if you want to add methods, like 
`string GetModeName()`. 

Modern C++
----------

Finally, with C++11 the feature was baked into the language with the `enum class`. 

```C++
enum class SimMode
{
   INITIALIZE = 1,
   RUN = 2,
   RESET = 3,
   PAUSE = 4
};

enum class Control
{
   START = 1,
   STOP = 2,
   PAUSE = 3
};

int main(int argc, char* argv[])
{
   SimMode mode = SimMode::INITIALIZE;
   Control control = Control::START;

   //... time passes

   control = Control::PAUSE;

   std::cout << static_cast<int>(control) << std::endl;
   // Correctly outputs: 3

   return 0;
}
```

A benefit to this is that it doesn't automatically convert to an integer (if you want the int, use `static_cast<int>`),
which prevents problems like:

```C++
if(mode == SimMode::RUN || SimMode::PAUSE)
{
...
```

When using the namespaces, that check would always return true, because the value of `SimMode::PAUSE` is always `3`. 
With the `enum class`, this will be compiler error because the `||` operator doesn't know what to do with the SimMode
type. Then you can re-write it to do what you actually wanted:

```C++
if(mode == SimMode::RUN || mode == SimMode::PAUSE)
{
...
```

Conclusion
----------

Unless you need to add additional methods to your enum, use the new `enum class`. 