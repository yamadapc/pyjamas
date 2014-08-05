void main()
{
  import std.exception;

  import bed;
  import pyjamas;

  describe("should", {
    describe("should(v)", {
      it("returns an Assertion", {
        assert(is(typeof(10.should) == Assertion));
      });
    });

    describe("Assertion", {
      describe(".message", {
        it("returns the correct message for binary operators", {
          auto a = new Assertion(10);
          a.operator = "equal";
          a.other = 20;
          assert(a.message == "expected 10 to equal 20");
        });

        it("returns the correct message for unary operators", {
          auto a = new Assertion("function");
          a.operator = "throw";
          assert(a.message == "expected function to throw");
        });

        it("returns the correct message for negated operators", {
          auto a = new Assertion(10);
          a.operator = "be";
          a.other = false;
          assert(a.not.message == "expected 10 to not be false");
        });
      });

      describe(".exist", {
        it("returns and asserts for existence", {
          auto a1 = new Assertion;
          a1.not.exist;
          auto a2 = new Assertion(null);
          a2.not.exist;
          auto a3 = new Assertion(10);
          a3.exist;
        });
      });

      describe(".True", {
        it("returns and asserts for true", {
          auto a = new Assertion(true);
          assert(a.be.True);
        });

        it("throws for false", {
          auto a = new Assertion(false);
          assertThrown!Exception(a.be.True);
        });
      });

      describe(".False", {
        it("returns and asserts for false", {
          auto a = new Assertion(false);
          assert(!a.be.False);
        });

        it("throws for true", {
          auto a = new Assertion(true);
          assertThrown!Exception(a.be.False);
        });
      });

      describe(".equal", {
        it("asserts whether two values are equal", {
          auto a = new Assertion(10);
          a.equal(10);
          a.not.equal(5);
          a.not;
          assertThrown!Exception(a.equal(2));
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

        it("throws for non-callable expressions", {
          assertThrown!Exception(should(10).Throw);
        });
      });
    });
  });
}
