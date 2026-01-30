# Global Game Jam 2026

Husky Game Dev's entry to Global Game Jam 2026!

## Project Structure

### `assets`

All created assets for the game should go in this folder, organized by name.

**Example:** A door sprite would go into `res://assets/door/door_sprite.png`

### `scripts`

All script files should go in this folder, organized by name.

**Example:** A door script would go into `res://scripts/door/door.gd`

## Styling Guidelines

Written by James / mykoala, adapted by Caeden

### Files

#### ALWAYS use lowercase snake case file naming:
```diff
- "My Text File.txt"
+ "my_text_file.txt"
```

**Reason:** Consistency, following official Godot guidelines.

#### ALWAYS prefer text format when saving Scenes and Resources
```diff
- my_cool_resource.res
- epic_scene.scn
+ my_cool_resource.tres
+ epic_scene.tscn
```

**Reason:** Files in binary do not work nicely for Git / version control.

### Code

#### ALWAYS use lowercase snake case when naming functions and variables:
```diff
- "My Epic Variable"
- MyEpicVariable
- My_Epic_Variable
- myEpicVariable
+ my_epic_variable
```

**Reason:** Consistency, following official Godot guidelines.

#### ALWAYS use pascal case when naming classes
```diff
- class_name my_custom_class
- class_name myCustomClass
+ class_name myCustomClass
```

**Reason:** Consistency, following official Godot guidelines.

#### ALWAYS prefix private/internal functions and variables with an underscore (`_`)
```diff
- var private_variable: bool = false
+ var _private_variable: bool = true
```

**Reason:** GDScript does not have access modifiers, so underscore prefixes are Godot's official guidelines.

#### NEVER use 'meta'/type-describing variable names:
```diff
- str_name
- k_constant
- p_parameter
- g_global_variable
+ name
+ constant
+ parameter
+ global_variable
```

**Reason:** We're not writing C in the 90s.

#### NEVER use abbreviations when naming functions and variables:
```diff
- var il_koalas: bool = false
+ var i_love_koalas: bool = true
```

**Reason:** Readable code is generally more readable than unreadable code, even if it takes a few more characters to type.

#### ALWAYS use static typing. No exceptions.
```diff
- var foo = 0
+ var foo: int = 1
```

**Reason:** Statically typed code is more readable and safer in GDScript.

#### NEVER shadow variables (engine should raise an error by default).
```diff
- var name: String = "custom" # Already defined in base Node class!
+ var custom_name: String = "custom" # Much better.
```

**Reason:** Variable shadowing can lead to messy and unintuitive code.


#### ALWAYS put annotations on a separate lines
```diff
- @export var foo: int = 0
+ @export
+ var foo: int = 0
```

```diff
- @tool class_name MyClass
+ @tool
+ class_name MyClass
```

**Reason:** Some annotations can get very long. Also a common code standard among other languages like C#.