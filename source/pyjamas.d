import std.conv;
import std.range;
import std.string;
import std.stdio;
import std.variant;

Assertion should(T)(const T value)
{
  Assertion a;
  a.value = value;
  return a;
}

struct Assertion
{
  Variant value;
  Variant other;
  string operator = "be";
  bool negated = false;
}

Assertion not(Assertion a)
{
  return Assertion(a.value, a.other, a.operator, true);
}

alias id be;
alias id as;
alias id of;
alias id a;
alias id and;
alias id have;
alias id which;

bool True(Assertion a)
{
  a.other = true;
  return a.ok(a.value == true);
}

bool False(Assertion a)
{
  a.other = false;
  return !a.ok(a.value == false);
}

T id(T)(T a)
{
  return a;
}

void Throw(T : Throwable = Exception, E)(Assertion a,
                                         lazy E expr,
                                         string file = __FILE__,
                                         size_t line = __LINE__)
{
  a.value = "function";
  a.operator = "throw";
  assertThrown(expr, a.message, file, line);
}

T ok(T)(Assertion a,
        const T expr,
        string file = __FILE__,
        size_t line = __LINE__)
{
  if(a.negated ? !expr : expr) return expr;
  throw new Exception(a.message, file, line);
}

Variant equal(T)(Assertion a,
                 const T other,
                 string file = __FILE__,
                 size_t line = __LINE__)
{
  a.operator = "equal";
  a.other = other;
  auto expr = a.value == other;
  a.ok(a.value == other, file, line);
  return a.value;
}

Variant exist(Assertion a, string file = __FILE__, size_t line = __LINE__)
{
  a.operator = "exist";

  if(!a.value.hasValue)
  {
    a.ok(false, file, line);
  }
  else if(a.value.convertsTo!(typeof(null)) &&
          a.value.get!(typeof(null)) is null)
  {
    a.ok(false, file, line);
  }

  return a.value;
}

string message(Assertion a)
{
  return format(
    "expected %s to %s%s%s",
    a.value.to!string,
    (a.negated ? "not " : ""),
    a.operator,
    (a.other.hasValue ? " " ~ a.other.to!string : "")
  );
}
