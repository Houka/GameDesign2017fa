# Logging/Retrieving Data
This folder contains files for logging and fetching data

Accessing the Logging API  
-------------------------  
Logging.hx can be treated as a static class. Instead of static functions, all functions are called through a singleton `Logging.getSingleton()`  

```
#if flash
import analytics.Logging;
#end
```

Calling the Logging API  
-----------------------  
Logging only works for flash targets. **Wrap all calls to Logging functions with conditional compilation statements**

Example: recording an event

```
#if flash
Logging.getSingleton().recordEvent(<event num>, <event detail>);
#end
```

For clarity, wrap any variables or functions used exclusively for logging within conditional compilation as well.

Example: eventNum is a class field used only for logging

```
#if flash
private var eventNum:Int;
#end
```