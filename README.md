[Live Share]: https://visualstudio.microsoft.com/services/live-share/
[EditorConfig]: https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig
[LaTeX Workshop]: https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
[Remote - Containers]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

# miami-university-cse-667-group-project

Paper: <https://proxy.lib.miamioh.edu/login?url=https://link.springer.com/article/10.1007/s10623-020-00741-y>

Distribution of work:

LaTeX guide: <https://en.wikibooks.org/wiki/LaTeX>

## Setup

```bash
git config core.autoCrlf input
```

Install the following Visual Studio Code extensions:

- [Remote - Containers]
- [EditorConfig]
- [Live Share]
- [LaTeX Workshop]

## Usage

Committing changes:

```bash
git add . -p
git commit
```

Building PDF:

```bash
# Inside Visual Studio Code dev container
make

# On commandline
docker run --rm -v "$(pwd):/pwd" --workdir /pwd blang/latex:ctanfull make
```