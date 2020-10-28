# bashrc.d

## Debug

```bash
# empty shell
env -i /usr/local/bin/bash

# empty env
env -i HOME="$HOME" /usr/local/bin/bash -c 'env'

# login shell
time env -i HOME="$HOME" LOG4BASH_LOG_LEVE=DEBUG /usr/local/bin/bash -l -c 'env'
```
