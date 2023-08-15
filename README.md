# tc-lockbox-dc-issue


Issue:

If the to-be-updated docker image has the same hash but a different tag during a lockbox update, the refs get wrangled up and the docker-compose is referencing into the void.

Context:

- clean & fresh flashed system with Tezi from the combined image
- offline update through lockbox with docker-compose only
- access to the internet from the SoM is blocked 

# Reproduce artefacts

1. build combined Tezi image (see `build.sh`)
2. Make sure to have your Torizon platform credentials ready in `.credentials.zip` (or adapt `build.sh` accordingly)
3. Upload docker-compose package to Torizon platform  (adapt `build.sh` to push packages)
4. Create lockboxes on the Torizon platform web ui, one for the docker-compose with the same hash and one for the other (use the same names as used in the build script)
5. Create lockboxes (adapt `build.sh` to create lockboxes)

All artefacts are available in the `cache` directory:
- lockbox with the same docker image digest but different tag
- lockbox with a different docker image digest and different tag 
- Tezi combined image

## Reproduce issue

1. flash the SoM with the combined Tezi image
2. There‘s one docker image running (an http server listening on port 3000)
3. Copy the lockbox with the same docker image digest to the target and place a symlink to `/media/aktualizr` as root
4. Wait for aktualizr to update the docker images
5. The new images are running (although the docker image ref is still the old tag)
6. Check the ref in the new docker-compose (`/var/sota/storage/docker-compose/docker-compose.yml`). It is pointing to a tag which is not available on the system (with prefix `digest`). 
7. After a reboot, no docker containers are running anymore because they could not be loaded

Attention: access to the internet from the SoM needs to be blocked probably (to avoid side effects)
