import std.conv;
import std.exception;
import std.range;
import std.string;
import std.traits;
import std.variant;

Assertion!T should(T)(T value)
{
  return new Assertion!T(value);
}

class Assertion(T)
{
  static bool callable = isCallable!T;
  bool negated = false;
  string operator = "be";
  T value;

  this() {};
  this(T _value)
  {
    value = _value;
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

  Assertion not()
  {
    negated = !negated;
    return this;
  }

  U ok(U)(U expr,
          lazy string message,
          string file = __FILE__,
          size_t line = __LINE__)
  {
    if(negated ? !expr : expr) return expr;
    throw new Exception(message, file, line);
  }

  T equal(U)(U other,
             string file = __FILE__,
             size_t line = __LINE__)
  {
    auto t_other = other.to!T;
    ok(value == other, message(other), file, line);
    return value;
  }

  T exist(string file = __FILE__, size_t line = __LINE__)
  {
    static if(is(T == bool))
    {
      return value;
    }
    else
    {
      operator = "exist";
      if(!value)
      {
        ok(false, message, file, line);
      }
      return value;
    }
  }

  string message(U)(U other)
  {
    return format("expected %s to %s%s%s", value.to!string,
                                           (negated ? "not " : ""),
                                           operator,
                                           (" " ~ other.to!string));
  }

  string message()
  {
    return format("expected %s to %s%s", value.to!string,
                                           (negated ? "not " : ""),
                                           operator
                                           );
  }

  static if(is(T == bool))
  {
    bool True(string file = __FILE__, size_t line = __LINE__)
    {
      return ok(value == true, message(true), file, line);
    }

    bool False(string file = __FILE__, size_t line = __LINE__)
    {
      return !ok(value == false, message(false), file, line);
    }
  }

  static if(isCallable!T)
  {
    void Throw(T : Throwable = Exception)(string file = __FILE__,
                                          size_t line = __LINE__)
    {
      operator = "throw";
      assertThrown!T(value(), message, file, line);
    }
  }

}
