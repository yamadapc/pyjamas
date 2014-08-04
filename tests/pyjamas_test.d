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
          Assertion a;
          a.value = 10;
          a.operator = "equal";
          a.other = 20;
          assert(a.message == "expected 10 to equal 20");
        });

        it("returns the correct message for unary operators", {
          Assertion a;
          a.value = "function";
          a.operator = "throw";
          assert(a.message == "expected function to throw");
        });

        it("returns the correct message for negated operators", {
          Assertion a;
          a.value = 10;
          a.operator = "be";
          a.other = false;
          assert(a.not.message == "expected 10 to not be false");
        });
      });

      describe(".exist", {
        it("returns and asserts for existence", {
          Assertion a1;
          a1.not.exist;
          Assertion a2;
          a2.value = null;
          a2.not.exist;
          Assertion a3;
          a3.value = 10;
          a3.exist;
        });
      });

      describe(".True", {
        it("returns and asserts for true", {
          Assertion a;
          a.value = true;
          assert(a.be.True);
        });

        it("throws for false", {
          Assertion a;
          a.value = false;
          assertThrown!Exception(a.be.True);
        });
      });

      describe(".False", {
        it("returns and asserts for false", {
          Assertion a;
          a.value = false;
          import std.stdio;
          assert(!a.be.False);
        });

        it("throws for true", {
          Assertion a;
          a.value = true;
          assertThrown!Exception(a.be.False);
        });
      });

      describe(".equal", {
        it("asserts whether two values are equal", {
          Assertion a;
          a.value = 10;
          a.equal(10);
          a.not.equal(5);
          assertThrown!Exception(a.equal(2));
        });
      });
    });
  });
}
