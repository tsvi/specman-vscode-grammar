// SYNTAX TEST "source.specman" "Context dependent"

<'

type var : [var];

struct s {
  var : var;
  keep var == var;

  event var;

  var():var @var is {
    var var: var = var;

    return var;
  }	
};

'>
