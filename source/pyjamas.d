import std.conv;
import std.exception;
import std.range;
import std.string;
import std.traits;
import std.variant;

Assertion should(T)(const lazy T value)
{
  return new Assertion(value);
}

class Assertion
{
  Variant value;
  Variant other;
  string operator = "be";
  bool negated = false;
  bool callable = false;

  this() {};
  this(E)(const E _value)
  {
    static if(isCallable!E) callable = true;
    value = _value;
  }

  Assertion not()
  {
    negated = !negated;
    return this;
  }

  bool True(string file = __FILE__, size_t line = __LINE__)
  {
    other = true;
    return ok(value == true, file, line);
  }

  bool False(string file = __FILE__, size_t line = __LINE__)
  {
    other = false;
    return !ok(value == false, file, line);
  }

  void Throw(T : Throwable = Exception)(string file = __FILE__,
                                        size_t line = __LINE__)
  {
    if(!callable)
    {
      operator = "be callable and throw";
      ok(false, file, line);
    }

    operator = "throw";
    assertThrown!T(value(), message, file, line);
  }

  T ok(T)(const T expr,
          string file = __FILE__,
          size_t line = __LINE__)
  {
    if(negated ? !expr : expr) return expr;
    throw new Exception(message, file, line);
  }

  Variant equal(T)(const T _other,
                   string file = __FILE__,
                   size_t line = __LINE__)
  {
    operator = "equal";
    other = _other;
    auto expr = value == other;
    ok(value == _other, file, line);
    return value;
  }

  Variant exist(string file = __FILE__, size_t line = __LINE__)
  {
    operator = "exist";

    if(!value.hasValue)
    {
      ok(false, file, line);
    }
    else if(value.convertsTo!(typeof(null)) &&
            value.get!(typeof(null)) is null)
    {
      ok(false, file, line);
    }

    return value;
  }

  string message()
  {
    return format(
      "expected %s to %s%s%s",
      value.to!string,
      (negated ? "not " : ""),
      operator,
      (other.hasValue ? " " ~ other.to!string : "")
    );
  }

  alias id be;
  alias id as;
  alias id of;
  alias id a;
  alias id and;
  alias id have;
  alias id which;

  Assertion id()
  {
    return this;
  }
}
