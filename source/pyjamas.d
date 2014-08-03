import std.conv;
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
  string operator = " be ";
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
  return a.ok(a.value == true);
}

bool False(Assertion a)
{
  return !a.ok(a.value == false);
}

T id(T)(T a)
{
  return a;
}

T ok(T)
(Assertion a, const T expr, string file = __FILE__, size_t line = __LINE__)
{
  if(a.negated ? !expr : expr) return expr;
  assert(false, a.message);
}

Variant equal(T)(Assertion a, const T other, string file = __FILE__, size_t line = __LINE__)
{
  a.operator = "equal";
  a.other = other;
  auto expr = a.value == other;
  a.ok!T(a.value == other);
  return a.value;
}

T exist(T)(Assertion!T a, T value = null)
{
  a.operator = "exist";
  if(!(a.value is null))
  {
    a.ok(true);
    return a.value;
  }
  else if(!(value is null))
  {
    a.ok(true);
    return value;
  }
  else a.ok;
}

string message(Assertion a)
{
  return format(
    "expected %s to %s%s %s",
    a.value.to!string,
    (a.negated ? "not " : ""),
    a.operator,
    a.other.to!string
  );
}
