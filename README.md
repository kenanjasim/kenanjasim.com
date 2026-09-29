# kenanjasim.com

Source for [kenanjasim.com](https://kenanjasim.com), my portfolio and CV. My blog lives
separately at [kenan.sh](https://kenan.sh).

Built with [Hugo](https://gohugo.io/) and a vendored copy of the
[hugo-coder](https://github.com/luizdepra/hugo-coder) theme (see `themes/hugo-coder/VENDORED.md`).

## Layout

| Path | What |
|---|---|
| `data/cv.toml` | All CV content: intro, experience, skills, projects, education |
| `layouts/_partials/home/` | Overrides that render `data/cv.toml` as a one-page CV |
| `assets/css/cv.css` | Styling on top of the theme, including the print styles used for the PDF |
| `scripts/build-cv-pdf.sh` | Prints the home page to `static/cv.pdf` with headless Chrome |

## Development

```bash
hugo server
```

Entries in `data/cv.toml` that start with `TODO` are placeholders. They're highlighted under
`hugo server` and left out of production builds, and each one is printed as a build warning.

The downloadable CV is the same page printed to PDF, so `data/cv.toml` is the single source for
both. `static/cv.pdf` isn't committed. CI generates it, or run `scripts/build-cv-pdf.sh` locally
(needs Chrome or Chromium). The old LaTeX CV lives in this repo's history (`cv/`, removed) and in
the original `kenanjasim/cv` repository.

## Deployment

GitHub Actions prints the CV PDF, builds the site, then deploys to GitHub Pages on every push to
`main` (`.github/workflows/deploy.yaml`). Other branches and PRs get a CI build only
(`ci.yaml`). The custom domain `kenanjasim.com` is set in the repository's Pages settings, with DNS
on Cloudflare.

`cloudflare/` has the redirect rules and CSVs that send the old blog URLs on kenanjasim.com to
kenan.sh.
