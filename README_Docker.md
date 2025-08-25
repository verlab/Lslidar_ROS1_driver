# LSLidar ROS1 Driver - Docker Tutorial

This tutorial explains how to run the LSLidar ROS1 driver using Docker. The project includes a pre-configured Docker setup that makes it easy to get started without installing ROS and dependencies on your host system.

## Prerequisites

- Docker installed on your system
- Docker Compose installed
- NVIDIA GPU with drivers (optional, for GPU acceleration)
- USB access to your LSLidar device

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Lslidar_ROS1_driver
```

### 2. Build the Docker Image

```bash
docker compose build
```

This will build the Docker image with all necessary dependencies including:
- ROS Noetic Desktop Full
- PCL libraries
- Boost libraries
- Eigen3
- LSLidar driver source code

### 3. Run the Driver

#### Option A: Using Docker Compose (Recommended)

```bash
docker compose up
```

This will:
- Start the container with the LSLidar driver
- Automatically launch the `lslidar_cx.launch` file
- Mount necessary USB devices and network interfaces
- Enable GPU acceleration if available

#### Option B: Interactive Mode

If you want to run commands interactively:

```bash
docker compose run --rm lslidar_driver bash
```

Then inside the container:

```bash
source devel/setup.bash
roslaunch lslidar_driver lslidar_cx.launch
```

## Available Launch Files

The driver supports multiple LSLidar models. You can modify the `docker compose.yml` file to use different launch files:

- **lslidar_cx.launch** - For CX series LSLidars (default)
- **lslidar_ls.launch** - For LS series LSLidars
- **lslidar_ch.launch** - For CH series LSLidars
- **lslidar_double.launch** - For dual LSLidar setups

To use a different launch file, edit the `docker compose.yml` and change the command line:

```yaml
command: >
  bash -c "
    source devel/setup.bash &&
    roslaunch lslidar_driver lslidar_ls.launch
  "
```

## Configuration

### USB Device Access

The Docker setup automatically mounts USB devices. If you encounter permission issues, you may need to add your user to the `docker` group:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Network Configuration

The container runs with `network_mode: host` to ensure proper ROS communication. This means the container shares the host's network stack.

### GPU Acceleration

If you have an NVIDIA GPU, the setup automatically enables GPU acceleration. Make sure you have:
- NVIDIA drivers installed on the host
- nvidia-docker2 installed
- Docker runtime set to nvidia

## Troubleshooting

### Common Issues

1. **USB Device Not Found**
   - Ensure the LSLidar is connected

2. **ROS Master Connection Issues**
   - The container uses host networking, so ROS_MASTER_URI should point to localhost
   - Ensure no firewall is blocking ROS communication

3. **Permission Denied Errors**
   - Run `docker compose` with appropriate permissions
   - Check if your user is in the docker group

4. **GPU Not Working**
   - Verify nvidia-docker2 is installed
   - Check if `nvidia-smi` works on the host
   - Ensure the container has access to GPU devices

### Debug Mode

To run in debug mode with more verbose output:

```bash
docker compose run --rm lslidar_driver bash -c "
  source devel/setup.bash &&
  roslaunch --verbose lslidar_driver lslidar_cx.launch
"
```

## Development

### Modifying the Driver

To modify the driver source code:

1. Make changes to the source files
2. Rebuild the Docker image: `docker compose build`
3. Run the updated container

### Adding Dependencies

To add new dependencies, edit the `Dockerfile`:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-new-package \
    && rm -rf /var/lib/apt/lists/*
```

Then rebuild the image.

## Stopping the Driver

To stop the running container:

```bash
docker compose down
```

Or if running in the foreground, use `Ctrl+C`.

## Cleanup

To remove all Docker resources:

```bash
docker compose down --rmi all --volumes --remove-orphans
```

## Support

For issues related to:
- **Docker setup**: Check this README and Docker documentation
- **LSLidar driver**: Refer to the main project README files
- **ROS**: Consult ROS documentation and community forums

## License

This Docker setup follows the same license as the main LSLidar ROS1 driver project.
