Build the entire infrastructure with Terraform and refactor to modules.


1.  Data types 
   
   The result of an expression is a value. All values have a type, which dictates where that value can be used and what transformations can be applied to it.

    Data types 

   a)  string: a sequence of Unicode characters representing some text, like "hello".

   b)  number: a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185.

   c) bool: a boolean value, either true or false. bool values can be used in conditional logic.

   d) list (or tuple): a sequence of values, like ["us-west-1a", "us-west-1c"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.

   d) map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}

   storageProfile = {
        storage_mb                      = 102400
        backup_retention_days           = 15
        geo_redundant_backup_enabled    = false
        administrator_login             = "pgadmin1223"
        }


2.  Functions 
    - Helps do things easily
    - transforming data. Iterating through arrays and maps


- Numeric functions 
  - max(12, 54, 3)
  - min(12, 54, 3)
  - ceil(5)
  - ceil(5.1)
  - floor(5)
  - floor(4.9)

- String functions
  - lower()
  - upper() - upper("dare")

- Collection functions 
  - flatten([["a", "b"], [], ["c"]])
  - flatten([[["a", "b"], []], ["c"]])
  - merge({a="b", c="d"}, {e="f", c="z"})
  - reverse([1, 2, 3])
  - concat(["a", ""], ["b", "c"])
  - element(["a", "b", "c"], 1)
  
- Type Conversion
  - tomap({"a" = 1, "b" = 2})
  - tolist(["a", "b", "c"])

- Filesystem 
  - basename("/Users/dare/Downloads/aws-project-darey/june/darey-masterclass/week4/Notes.md")
  - pathexpand("~/.ssh/id_rsa")
  - fileexists("/Users/dare/Downloads/aws-project-darey/june/darey-masterclass/week4/Notes.md") 


3.  Modules

-- Variables and Refactoring
-- Modules

Modules - A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration consisting of a single directory with one or more .tf files is a module. When you run Terraform commands directly from such a directory, it is considered the root module

-- custom modules
-- input variables
-- output variables
-- tfvars
-- public modules

1. create a module folder
2. copy the 2-3 and 4 files 
3. create main.tf
4. copy the provider
5. update the cidr in module by removing the hard coded value
6. create a variables file inside the module
7. provide the value in the root module
8. create the variables file in the root module
9. create an environment folder to simulate multiple environments
10. create the tfvars in the environment folder to simulate deployment into multiple environments.


Next steps

1. Containerisation and Kubernetes
2. Videos to watch
   1. ..........
   2. ..........
   3. ..........
   4. ..........
   5. ..........

