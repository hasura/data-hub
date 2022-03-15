# Contributing Guide

All the samples listed in the Data Hub are available in the `config.json` file of this repo. To add a new item, please make a fork of this repo, edit the config.json file and create a pull request.

The format of items in the config.json file is as follows:

```
{
  "name": "<name-of-your-integration>",
  "logo_url": "URL of the logo",
  "short_desc": "A short description about the integration, preferably in less than 100 characters.",
  "url_path": "The URL path to be generated on the website. Use small case and hyphens between words",
  "github_repo": {
    "name": "user/repo",
    "branch": "main",
    "readme_repo_path": "/README.md"
  },
  "developed_by": "Who developed this integration?",
  "released_on": "The date which this integration is releasing on the Hub",
  "last_updated": "The date when it was last updated on the Hub",
  "additional_resources": [
    {
      "text": "Any anchor text",
      "link": "Link to some docs"
    }
  ],
  "additional_images": [
    {
      "url": "",
      "alt": ""
    }
  ],
  "video_demo": "YouTube demo video in the format of https://www.youtube.com/embed/<id>",
  "integration_link": "Link to github repo or website with instructions on how to add to Hasura project",
  "categories": [
    {
      "name": "Enter a category name that fits in the current list"
    }
  ],
  "is_featured": false,
  "coming_soon": false,
  "type": "Remote Schema or Database Schema"
}
```

Copy the above object, modify the details accordingly and add it to the end of the config.json file.

## Editing existing listings

In case you find any discrepancies in the existing list of items or if there are broken links, images etc, feel free to modify the same and submit a PR. We update and review featured listings from time to time.
