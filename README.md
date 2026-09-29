# kenanjasim.com

Source for [kenanjasim.com](https://kenanjasim.com), my portfolio and CV. My blog lives
separately at [kenan.sh](https://kenan.sh).

Built with [Hugo](https://gohugo.io/) and a vendored copy of the
[hugo-coder](https://github.com/luizdepra/hugo-coder) theme (see `themes/hugo-coder/VENDORED.md`).

## Layout

| Path | What |
|---|---|
| `data/cv.toml` | All page content: intro, experience, skills, projects, education |
| `layouts/_partials/home/` | Overrides that render `data/cv.toml` as a one-page CV |
| `assets/css/cv.css` | Styling on top of the theme |
| `cv/` | LaTeX source of the downloadable CV (history imported from `kenanjasim/cv`) |

## Development

```bash
hugo server
```

Entries in `data/cv.toml` that start with `TODO` are placeholders. They're highlighted under
`hugo server` and left out of production builds, and each one is printed as a build warning.

`static/cv.pdf` isn't committed. CI compiles it from `cv/cv.tex`. To preview the download link
locally, build the PDF (`cd cv && latexmk -xelatex cv.tex`) and copy it to `static/cv.pdf`.

## Deployment

GitHub Actions builds the CV PDF and the site, then deploys to GitHub Pages on every push to
`main` (`.github/workflows/deploy.yaml`). Other branches and PRs get a CI build only
(`ci.yaml`). The custom domain `kenanjasim.com` is set in the repository's Pages settings, with DNS
on Cloudflare.

`cloudflare/` has the redirect rules and CSVs that send the old blog URLs on kenanjasim.com to
kenan.sh.
