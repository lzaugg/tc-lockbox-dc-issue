# tc-lockbox-dc-issue


Issue:

If the to-be-updated docker image has the same hash but a different tag during a lockbox update, the refs get wrangled up and the docker-compose is referencing into the void.

Context:

- clean & fresh flashed system with Tezi from the combined image
- offline update through lockbox with docker-compose only

Reproduce:
1. build combined Tezi image (see `build.sh`)
2. Make sure to have your Torizon platform credentials ready in `.credentials.zip` (or adapt `build.sh` accordingly)
3. Upload docker-compose package to Torizon platform  (adapt `build.sh` to push packages)
4. Create lockboxes on the Torizon platform web ui, one for the docker-compose with the same hash and one for the other (use the same names as used in the build script)
5. Create lockboxes (adapt `build.sh` to create lockboxes)
