# t26_scoped_model_pattern

So why should I use ScopedModelPattern?

A)  The Redux (previous tutorial) plugin is based on SMP

B)  Set of utilites that were pulled out of the core Fuchia(new Google OS) repository 
    
Some theory:

    SM is based on InheritedWidget 

    notifyListeners() : 
    Because we are using ScopedModels and because we want to make it so, 
    that the actual widgets update when the model changes.. 

    It will notify the state tree that our model has been changed therefore widgets connected to the model needs to be changed as well. 