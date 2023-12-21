# Hardware Documentation

Provides a pipeline for hardware documentation. Renders and meshes from different repos are pushed into a single repo and github pages site for easy tracking.

## Usage
1. Create a repo from this template. Save your designs in the new repo. For mechanical designs you can add renders of your designs and meshes(.objs, etc) for use in 3D simulations. Create a directory for the renders and meshes as is appropriate. The structure the meshes dir is:
```
root_dir
-> render
  -> render1
    -> render1.png
```
2. In every organization where the renders/meshes are to be pushes, ensure that you create the coresponding template repo from either [render-template](https://github.com/brianmechanisms/render-template) or [meshes-template](https://github.com/brianmechanisms/meshes-template). This step is required because [github API](https://docs.github.com/rest/repos/repos#create-a-repository-using-a-template) does not yet provide a means of creating a repo from a template oned by a different organization.

Next you will need to edit the yaml file in `./config`.

```yaml
render:
  repo: "render" # name of repo in which renders are to be pushed
  dir: "render" # name of local directory containing renders
  template: "pacars/render-template" # ensure that this is in the same organization as where you want to have the render repo
  name: "Pacar-2 Concept" # Name of current project
  private: false # leave as is for now
  owner: "brianmechanisms" # owner of repo. Should be same as template owner for now
render1:
  ... You can have multipe renders
meshes:
  ... same for meshes
```
3. Setting Up Personal Access Tokens
- Set up your organizations to use [personal access tokens](https://github.com/settings/tokens)
- Create personal access tokens for the organizations with `Actions`, `Administration`, `Commit Statuses`, `Contents`, `Deployments`, `Pages`, `Secrets`, `Worflows`, `Metadata` permissions
- Set up repo secret for the repo you created from this template with name `DEPLOY_TOKEN_{owner}` for each item entry in the yaml file. This will be used to create and manage the corresponding repo in that organization.

## Issues
- [ ] Lack of autoupdate for Hardware Documentation templates. As a workaround, clone [parent repo](https://github.com/brianmechanisms/hardware-docs-template) instead of using it as a template.
- [ ] Lack of autoupdate for render & mesh templates. As a workaround, clone [render parent repo](https://github.com/brianmechanisms/render-template) and [meshes parent repo](https://github.com/brianmechanisms/meshes-template) instead of using them as templates.
- [ ] Multiple/Duplicate render/meshes templates currently needed.

## Todo
- [ ] Use single template for `render`, `meshes`, `simulation`, etc.
