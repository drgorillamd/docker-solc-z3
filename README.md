
## Commands

### Build the image
```
docker build -t solc-z3 .
```

### Run any arbitrary command in the contrainer
```
docker run -v $(pwd):$(pwd) -w $(pwd) solc-z3 {YOUR_COMMAND}
```