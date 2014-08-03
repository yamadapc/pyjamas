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
      describe(".True", {
        it("returns and asserts for true", {
          Assertion a;
          a.value = true;
          assert(a.be.True);
        });

        it("throws for false", {
          Assertion a;
          a.value = false;
          assertThrown!AssertError(a.be.True);
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
          assertThrown!AssertError(a.be.False);
        });
      });

      describe(".equal", {
        it("asserts whether two values are equal", {
          Assertion a;
          a.value = 10;
          a.equal(10);
          a.not.equal(5);
          assertThrown!AssertError(a.equal(2));
        });
      });

      describe(".eql", {
        it("assets whether two ranges are deep equal", {
          Assertion a;
          a.value = [ 0, 1, 2, 3 ];
          a.eql([0, 1, 2, 3]);
          a.not.eql([0, 1, 2, 6]);
        });
      });
    });
  });
}
