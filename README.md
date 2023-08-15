# tc-lockbox-dc-issue


Issue:

If the to-be-updated docker image has the same hash but a different tag during a lockbox update, the refs get wrangled up and the docker-compose is referencing into the void.

Context:

- clean & fresh flashed system with Tezi from the combined image
- offline update through lockbox with docker-compose only
- access to the internet from the SoM is blocked 

## Reproduce artefacts

1. build combined Tezi image (run function `create_combined`, see `build.sh`)
2. Make sure to have your Torizon platform credentials ready in `.credentials.zip` or adapt `build.sh` accordingly 
3. Upload docker-compose package to Torizon platform  (run function `push_packages`, see `build.sh`)
4. Create lockboxes on the Torizon platform web UI, one for the docker-compose with the same hash (named `tc-lockbox-dc-issue-apps-same-hash`, see `build.sh`)  and one for the other (named `tc-lockbox-dc-issue-apps-different-hash`, see `build.sh`).
5. Create lockboxes (run function `create_lockbox`, see `build.sh`)

All artefacts are available in the `cache` directory:

- lockbox with the same docker image digest but different tag
- lockbox with a different docker image digest and different tag 
- Tezi combined image

E.g. of `cache` directory after creating the artefacst

```bash
tc-lockbox-dc-issue git:(main) ✗ ls -l cache
total 17736
drwxr-xr-x@  5 lzaugg  staff      160 Aug 15 12:01 bundle
drwxr-xr-x@ 12 lzaugg  staff      384 Aug 15 12:01 tc-lockbox-dc-issue-Tezi
drwxr-xr-x@ 15 lzaugg  staff      480 Aug 15 12:01 tc-lockbox-dc-issue-Tezi-combined
drwxr-xr-x@  4 lzaugg  staff      128 Aug 15 10:29 tc-lockbox-dc-issue-lockbox-apps-different-hash
drwxr-xr-x@  4 lzaugg  staff      128 Aug 15 10:28 tc-lockbox-dc-issue-lockbox-apps-same-hash
```

## Reproduce issue

1. flash the SoM with the combined Tezi image (e.g. `npx http-server -p 8089 .`, start SoM in Tezi recovery mode, add feed of the build machine like `http://<build-machine-ip>:8089/images.json`)
2. There‘s one docker image running (an http server listening on port 3000)
3. Copy the lockbox with the same docker image digest (named `tc-lockbox-dc-issue-apps-same-hash`) to the target and place a symlink to `/media/aktualizr` as root
4. Wait for aktualizr to update the docker images
5. The new images are running (although the docker image ref is still the old tag when checking with `docker images`)
6. Check the ref in the new docker-compose (`/var/sota/storage/docker-compose/docker-compose.yml`). It is pointing to a tag which is not available on the system (with prefix `digest`). 
7. After a reboot, no docker containers are running anymore because they could not be loaded

Attention: access to the internet from the SoM needs to be blocked probably (to avoid side effects)
