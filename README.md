# Idealixir

A command-line interface to use the [Idealista](http://idealista.com/) search API.

## Installation

```
mix escript.build
```

## Usage
```
./idealixir search \
  --center="40.42938099999995,-3.7097526269835726" \
  --bedrooms="3" \
  --country="es" \
  --maxItems="50" \
  --numPage="1" \
  --distance="452" \
  --propertyType="homes" \
  --operation="sale"
```

All search parameters supported by the search API are supported as command line switches as shown.
