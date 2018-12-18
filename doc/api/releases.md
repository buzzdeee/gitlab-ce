# Releases

> [Introduced][23795] in GitLab 11.7.

A list of the published Releases are available to everyone.

## List releases
Paginated list of releases, sorted by `created_at`

```
GET /projects/:id/releases
```

## Release by tag name
Get a release for the given tag

```
GET /projects/:id/release/:tag_name
```

## Create a release
Users with push access to the repository can create a release.

```
POST /projects/:id/releases
```

### Request Body

|Attribute    |Type         |Required     |Description                              |
|:------------|:------------|:------------|:----------------------------------------|
|`name`       |string       |yes          |release name                             |
|`tag_name`   |string       |yes          |the tag where the release will be created|
|`description`|string       |no           |markdown description of the release      |
|`ref`        |string       |yes          |if `tag_name` doesn't exist in the repository, the release will be created on `ref`. It can be a commit SHA, another tag name, or branch name |
|`assets`     |object       |yes          |todo      |
|`assets`     |array        |yes          |Array with assets links                  |


#### Post data using JSON content
```json
{
  "name": "Bionic Beaver",
  "tag_name": "18.04",
  "description": "## changelog\n\n* line 1\n* line2",
  "ref": "stable-18-04",
  "assets": {
    "links": [
      {
         "name": "release-18.04.dmg",
         "url": "https://my-external-hosting.example.com/scrambled-url/"
      },
      {
         "name": "binary-linux-amd64",
         "url": "https://gitlab.com/gitlab-org/gitlab-ce/-/jobs/artifacts/v11.6.0-rc4/download?job=rspec-mysql+41%2F50"
      }
    ]
  }
}
```

## Update a release
```
PUT /projects/:id/release/:tag_name
```

## Delete a release
Deleting a release will not delete the associated tag

```
DELETE /projects/:id/release/:tag_name
```
