void main()
{
  import std.exception;

  import bed;
  import pyjamas;

  describe("should", {
    describe("should(v)", {
      it("returns an Assertion", {
        assert(is(typeof(10.should) == Assertion!int));
      });
    });

    describe("Assertion", {
      describe(".message", {
        it("returns the correct message for binary operators", {
          auto a = new Assertion!int(10);
          a.operator = "equal";
          assert(a.message(20) == "expected 10 to equal 20");
        });

        it("returns the correct message for unary operators", {
          auto a = new Assertion!string("function");
          a.operator = "throw";
          assert(a.message == "expected function to throw");
        });

        it("returns the correct message for negated operators", {
          auto a = new Assertion!int(10);
          a.operator = "be";
          assert(a.not.message(false) == "expected 10 to not be false");
        });
      });

      describe(".exist", {
        it("returns and asserts for existence", {
          auto a1 = new Assertion!string;
          a1.not.exist;
          auto a2 = new Assertion!string(null);
          a2.not.exist;
          auto a3 = new Assertion!int(10);
          a3.exist;
        });
      });

      describe(".True", {
        it("returns and asserts for true", {
          auto a = new Assertion!bool(true);
          assert(a.be.True);
        });

        it("throws for false", {
          auto a = new Assertion!bool(false);
          assertThrown!Exception(a.be.True);
        });
      });

      describe(".False", {
        it("returns and asserts for false", {
          auto a = new Assertion!bool(false);
          assert(!a.be.False);
        });

        it("throws for true", {
          auto a = new Assertion!bool(true);
          assertThrown!Exception(a.be.False);
        });
      });

      describe(".equal", {
        it("asserts whether two values are equal", {
          auto a = new Assertion!int(10);
          a.equal(10);
          a.not.equal(5);
          a.not;
          assertThrown!Exception(a.equal(2));
        });

        it("works for ranges", {
          auto a1 = new Assertion!(uint[])([1, 2, 3, 4]);
          a1.equal([1, 2, 3, 4]);
          auto a2 = new Assertion!(char[])([0, 2, 1]);
          a2.not.equal([1, 2, 3, 5]);
        });

        it("works for structs", {
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
        });
      });

      describe(".Throw", {
        it("asserts whether an expressions throws", {
          void throwing()
          {
            throw new Exception("I throw with 0!");
          }

          should(&throwing).Throw!Exception;
        });
      });
    });
  });
}
