/**
 * Authors: Pedro Tacla Yamada
 * Date: August 21, 2014
 * License: Licensed under the GPLv3 license. See LICENSE for more information.
 */
module pyjamas;

import std.algorithm : canFind, isSorted;
import std.conv : to;
import std.range : isInputRange, isForwardRange, hasLength, ElementEncodingType,
                   empty;
import std.regex : Regex, StaticRegex;// & std.regex.match
import std.string : format;
import std.traits : hasMember, isSomeString, isCallable, isAssociativeArray,
                    isImplicitlyConvertible, Unqual;

Assertion!T should(T)(T context)
{
  return new Assertion!T(context);
}

class Assertion(T)
{
  static bool callable = isCallable!T;
  bool negated = false;
  string operator = "be";
  T context;

  this() {};
  this(T _context)
  {
    context = _context;
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
    ok(context == other, message(other), file, line);
    return context;
  }

  T exist(string file = __FILE__, size_t line = __LINE__)
  {
    static if(isImplicitlyConvertible!(T, typeof(null)))
    {
      operator = "exist";
      if(context == null)
      {
        ok(false, message, file, line);
      }
    }
    return context;
  }

  string message(U)(U other)
  {
    return format("expected %s to %s%s%s", context.to!string,
                                           (negated ? "not " : ""),
                                           operator,
                                           (" " ~ other.to!string));
  }

  string message()
  {
    return format("expected %s to %s%s", context.to!string,
                                         (negated ? "not " : ""),
                                         operator);
  }

  bool biggerThan(U)(U other, string file = __FILE__, size_t line = __LINE__)
  {
    operator = "be bigger than";
    return ok(context > other, message(other), file, line);
  }

  bool smallerThan(U)(U other, string file = __FILE__, size_t line = __LINE__)
  {
    operator = "be smaller than";
    return ok(context < other, message(other), file, line);
  }

  static if(isForwardRange!T && __traits(compiles, context.isSorted))
  {
    bool sorted(string file = __FILE__, size_t line = __LINE__)
    {
      operator = "be sorted";
      return ok(context.isSorted, message, file, line);
    }
  }

  static if(isAssociativeArray!T) {
    void key(U)(U other, string file = __FILE__, size_t line = __LINE__)
    {
      operator = "have key";
      ok(!(other !in context), message(other), file, line);
    }
  }

  static if(isInputRange!T || isAssociativeArray!T)
  {
    U value(U)(U other, string file = __FILE__, size_t line = __LINE__)
    {
      static if(isAssociativeArray!T) auto pool = context.values;
      else auto pool = context;

      operator = "contain value";
      ok(canFind(pool, other), message(other), file, line);
      return other;
    }

    alias value include;
    alias value contain;
  }

  static if(hasLength!T || hasMember!(T, "string") || isSomeString!T)
  {
    U length(U)(U len, string file = __FILE__, size_t line = __LINE__)
    {
      operator = "have length of";
      ok(context.length == len, message(len), file, line);
      return len;
    }
  }

  import std.regex : Regex, StaticRegex;
  static if(isSomeString!T)
  {
    private alias BasicElementOfT = Unqual!(ElementEncodingType!T);
    private alias RegexOfT = Regex!(BasicElementOfT);
    private alias StaticRegexOfT = StaticRegex!(BasicElementOfT);

    auto match(RegEx)(RegEx re, string file = __FILE__, size_t line = __LINE__)
      if(is(RegEx == RegexOfT) ||
         is(RegEx == StaticRegexOfT) ||
         isSomeString!RegEx)
    {
      import std.regex : match;
      auto m = match(context, re);
      operator = "match";
      ok(!m.empty, message(re), file, line);
      return m;
    }
  }

  static if(is(T == bool))
  {
    bool True(string file = __FILE__, size_t line = __LINE__)
    {
      return ok(context == true, message(true), file, line);
    }

    bool False(string file = __FILE__, size_t line = __LINE__)
    {
      return !ok(context == false, message(false), file, line);
    }
  }

  static if(isCallable!T)
 {
    void Throw(T : Throwable = Exception)(string file = __FILE__,
                                          size_t line = __LINE__)
    {
      operator = "throw";
      bool thrown = false;
      try context();
      catch(T) thrown = true;
      ok(thrown, message(), file, line);
    }
  }

}
