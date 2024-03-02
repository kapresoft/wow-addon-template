## Steps in creating a new repo from this template

1. Create Repository from template via Github or Github CLI
2. Replace Template vars [Template_VARS.md](TEMPLATE_VARS.md)
   - can be scripted; see [StaxExchange: Find and replace words in text file recursively](https://unix.stackexchange.com/questions/269279/find-and-replace-words-in-text-file-recursively)
3. Rename toc files to AddonTemplate.toc, etc...

### Curse Forge Steps

1. Create Curse Forge Project
2. Configure Project; Integrate source control (Github)
3. Configure Automatic Packaging
4. Add build webhooks to repository (see Curse Forge docs)

### Curse Forge Resources

- [Preparing the PackageMeta File](https://support.curseforge.com/en/support/solutions/articles/9000197952-preparing-the-packagemeta-file)
- [Automatic Packaging](https://support.curseforge.com/en/support/solutions/articles/9000197281-automatic-packaging)

### See Also
- [Github: Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)


### Search and Replace

See scripts in ./dev/ folder and modify content, execute in order
Update with new Project Name and Project ID (Curse Forge)

- 1-rename.sh
- 2-replace-util-files.sh
- 3-replace-projectid.sh
- 4-replace-lua-files.sh
