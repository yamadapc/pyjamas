import std.exception;

import pyjamas;

@("Should(v)")
unittest {
    //  it("returns an Assertion", {
    assert(is(typeof(10.should) == Assertion!int));
}

@("Should Assertion")
unittest {
    //  it("can be instantiated for ranges of structs without `opCmp`", {
    struct Test {
        int a;
        int b;
    }

    cast(void) [ Test( 2, 3)].should;
}

@("Should Assertion.message")
unittest {
    //  it("returns the correct message for binary operators",
    {
        auto a = new Assertion!int( 10);
        a.operator = "equal";
        assert(a.message( 20) == "expected 10 to equal 20");
    }

    //  it("returns the correct message for unary operators",
    {
        auto a = new Assertion!string( "function");
        a.operator = "throw";
        assert(a.message == "expected function to throw");
    }

    //  it("returns the correct message for negated operators",
    {
        auto a = new Assertion!int( 10);
        a.operator = "be";
        assert(a.not.message( false) == "expected 10 to not be false");
    }
}

@("Should Assertion.exist")
unittest {
    //  it("returns and asserts for existence",
    {
        auto a1 = new Assertion!string;
        a1.not.exist;
        auto a2 = new Assertion!string( null);
        a2.not.exist;
        auto a3 = new Assertion!int( 10);
        a3.exist;
    }

}

@("Should Assertion.True")
unittest {
    // it("returns and asserts for true",
    {
        auto a = new Assertion!bool(true);
        assert(a.be.True);
    }

    // it("throws for false",
    {
        auto a = new Assertion!bool(false);
        assertThrown!Exception(a.be.True);
    }
}

@("Should Assertion.False")
unittest {
    // it("returns and asserts for false",
    {
        auto a = new Assertion!bool(false);
        assert(!a.be.False);
    }

    // it("throws for true",
    {
        auto a = new Assertion!bool(true);
        assertThrown!Exception(a.be.False);
    }
}

@("Should Assertion.equal")
unittest {
    //  it("asserts whether two values are equal",
    {
        auto a = new Assertion!int(10);
        a.equal(10);
        a.not.equal(5);
        a.not;
        assertThrown!Exception(a.equal(2));
    }

    //  it("works for ranges",
    {
        auto a1 = new Assertion!(uint[])([1, 2, 3, 4]);
        a1.equal([1, 2, 3, 4]);
        auto a2 = new Assertion!(char[])([0, 2, 1]);
        a2.not.equal([1, 2, 3, 5]);
    }

    //  it("works for structs",
    {
        struct Example
        {
            bool a = false;
            string f = "something";
        }

        auto e = Example(true, "here");
        auto a1 = new Assertion!(Example)(e);
        a1.equal(Example(true, "here"));

        auto a2 = new Assertion!(Example)(e);
        a1.not.equal(Example(true, "asdf"));
    }
}

@("Should Assertion.match")
unittest {
    // it("returns whether a string type matches a Regex",
    {
        import std.regex : regex;
        auto a = new Assertion!string( "something weird");
        assert(a.match( `[a-z]+`));
        assert(a.match( regex( `[a-z]+`)));
    }

    // it("returns whether a string type matches a StaticRegex",
    // FIX Broken case with ctRegex
    /*
    {
        import std.regex : ctRegex;
        auto a = new Assertion!string("something 2 weird");
        assert(!a.not.match(ctRegex!`^[a-z]+$`));
    }
    */

    // it("returns whether a string type matches a string regex",
    {
        auto a = new Assertion!string( "1234numbers");
        assert(a.match( `[0-9]+[a-z]+`));
        assert(!a.not.match( `^[a-z]+`));
    }
}

@("Should Assertion.value")
unittest {
    // it("asserts for arrays containing elements",
    {
        auto a = new Assertion!(int[])([1, 2, 3, 4, 5, 6]);
        a.include(4);
        a.not.include(7);
    }

    // it("asserts for associative arrays containing values",
    {
        auto a = new Assertion!(int[string])(["something": 2, "else": 3]);
        a.value(2);
        a.not.value(4);
    }

    // it("asserts for stirngs containing characters",
    {
        auto a = new Assertion!string("asdf1");
        a.include('a');
        a.include("sd");
        a.not.include(2);
    }
}

@("Should Assertion.length")
unittest {
    // it("asserts for length equality for strings",
    {
        auto a = new Assertion!string("1234567");
        a.have.length(7);
    }

    // it("asserts for length equality for arrays",
    {
        auto a = new Assertion!(int[])([1, 2, 3, 4, 5, 6]);
        a.have.length(6);
    }

    // it("asserts for length equality for associative arrays",
    {
        auto a = new Assertion!(string[string])([
        "something": "here",
        "what": "is",
        "this": "stuff",
        "we're": "doing"
        ]);
        a.have.length(4);
    }
}

@("Should Assertion.Throw")
unittest {
    // it("asserts whether an expressions throws",
    {
        void throwing()
        {
            throw new Exception("I throw with 0!");
        }

        should(&throwing).Throw!Exception;

        void notThrowing()
        {
            return;
        }

        should(&notThrowing).not.Throw;
    }
}

@("Should Assertion.key")
unittest {
    // it("asserts for `key` existence in types with `opIndex` defined",
    {
        auto aArr = [
          "something": "here",
        ];

        aArr.should.have.key("something");
        aArr.should.not.have.key("else");
    }
}

@("Should Assertion.sorted")
unittest {
    // it("asserts whether a range is sorted",
    {
        auto unsorted = [4, 3, 2, 1];
        assert(!new Assertion!(int[])(unsorted).not.sorted);
        auto sorted = [1, 2, 3, 4, 8];
        assert(new Assertion!(int[])(sorted).sorted);
    }
}

@("Should Assertion.biggerThan")
unittest {
    //it("asserts whether a value is bigger than other",
    {
        auto a1 = new Assertion!bool(true);
        a1.biggerThan(0);
        a1.biggerThan(false);

        auto a2 = new Assertion!string("aab");
        a2.biggerThan("aaa");
        a2.not.biggerThan("zz");
    }
}

@("Should Assertion.smallerThan")
unittest {
    // it("asserts whether a value is smaller than other",
    {
        auto a1 = new Assertion!bool(false);
        a1.smallerThan(1);
        a1.smallerThan(true);

        auto a2 = new Assertion!int(1000);
        a2.smallerThan(2000);
        a2.not.smallerThan(99);
    }
}
