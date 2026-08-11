# node-do-app — Working Notes

## Status
- Phase: Ready to push (test_project PASSED)

## Stack
- Node.js 20 / NestJS / TypeScript
- DigitalOcean Droplet s-1vcpu-1gb, nyc1
- Nginx reverse proxy (port 80 → 3000)
- PM2 process manager (run as root with --uid appuser)
- Terraform + Ansible
- GitHub Actions CI/CD

## Key Decisions
- NYC3 was unavailable at probe time → chose nyc1
- No managed DB at Tier 1
- Ansible runs all tasks as root (become: true) — avoids setfacl/become_user
  chmod issues (known platform issue with become_user on Ubuntu 22.04)
- PM2 started via root with --uid/--gid flags to run the process as appuser
- ansible.builtin.copy used for each src file individually (no synchronize/posix
  collection dependency)
- app files copied as root then ownership transferred to appuser before PM2 starts
- ESLint + Jest added as devDependencies (scaffold missed them)
- .eslintrc.js added with @typescript-eslint config
- spec test added for AppController

## Fixes Applied
- Fixed: become_user + setfacl failure → all tasks run as root, PM2 uses --uid flag
- Fixed: synchronize → ansible.builtin.copy per-file (no ansible.posix collection)
- Fixed: ESLint missing → added eslint + @typescript-eslint to package.json
- Fixed: package-lock.json mismatch → deleted stale, regenerated clean with test_project

## Pipeline Test
- PASSED: lint (ESLint) + test (Jest) all green

## TODO
- [x] test_project PASSED
- [ ] create_repo_and_push
- [ ] deploy
