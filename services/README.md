## Services

Some worker services are required for this application to run.

# Installing Services

The service files need to reside in `/etc/systemd/system` to be controlled by `systemctl`. The service files also need to reside in `/etc/systemd/system/mutli-user.target` in order for them to start automatically if the system was to restart.

You can either symlink these files from the application directory to both `../system` and `../mutli-user.target` or `cp` from the application directory to `../system` and them run `systemctl enable app.service` to have `systemctl` install, via symlink, `app.service` to `../mutli-user.target`.

## Start Services

- `systemctl start app.service`
- `systemctl start sidekiq.service`
- `systemctl start CreateUserConsumer@1.service` to start one instance.
- `systemctl start CreateUserConsumer@{1..N}.service` to start N number of instances.
- ...

## Restarting Services

- `systemctl restart app.service`
- `systemctl restart sidekiq.service`
- `systemctl restart CreateUserConsumer@*.service` to restart all running instances.
- `systemctl restart CreateUserConsumer@1.service` to restart running instance #1.
- `systemctl restart CreateUserConsumer@{1..10}.service` to restart 1-10 running instances.
- ...

## Stopping Services

- `systemctl stop app.service`
- `systemctl stop sidekiq.service`
- `systemctl stop CreateUserConsumer@*.service` to stop all running instances.
- `systemctl stop CreateUserConsumer@1.service` to stop running instance #1.
- `systemctl stop CreateUserConsumer@{1..10}.service` to stop 1-10 running instances.
- ...

# Deployment 

We need to ensure that the latest copy of any `*.service` file is the one being managed by `systemctl`. To do so, we should either symlink to the latest version of the `*.service` file or ensure we `cp` the most latest version. When a newer version of a `*.service` file is available, in order to verify its managing the right version, we need to run `systemctl daemon-reload` to reload the latest version within `systemctl`.

## Deployment Strategy

We won't need to run the same amount of workers on all servers. Production will most likely require more workers than staging and development. Since these numbers are a per server basis, we will want to manually start the number of instances, also manually change the number of instances if it were to change.

During deployment, `systemctl restart app.service` will be run and this will restart all instances of workers, as well as `sidekiq.service`.

# Restarting the Application

When you currently run `systemctl restart app.service` this will reload any and all instances of the consumers as well as `sidekiq.service`. This is indicated by the `[Unit]` section and `PartOf` directive in the file.
