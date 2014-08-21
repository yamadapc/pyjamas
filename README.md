pyjamas
=======
[![Build Status](https://travis-ci.org/yamadapc/pyjamas.svg)](https://travis-ci.org/yamadapc/pyjamas)
[![Gitter chat](https://badges.gitter.im/yamadapc/pyjamas.png)](https://gitter.im/yamadapc/pyjamas)
- - -

<img src="/logo-big.png" align="left"/>
A BDD assertion library for D.

## Example
```d
import pyjamas;

10.should.equal(10);
5.should.not.equal(10);
```

## Tests

Run tests with:
```
dub --config=test
```

## License

This code is licensed under the GPLv3 license. See the [LICENSE](LICENSE) file
for more information.
