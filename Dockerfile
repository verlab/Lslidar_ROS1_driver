FROM osrf/ros:noetic-desktop-full

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpcap-dev \
    libyaml-cpp-dev \
    libboost-all-dev \
    libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ROS dependencies
RUN apt-get update && apt-get install -y \
    ros-noetic-pcl-ros \
    ros-noetic-pcl-conversions \
    ros-noetic-diagnostic-updater \
    ros-noetic-message-generation \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
WORKDIR /lidar_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    mkdir -p src && \
    catkin_make"

# Copy source code
COPY . src/

# Build the driver
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin_make"

# Source setup
RUN echo "source /lidar_ws/devel/setup.bash" >> ~/.bashrc

# Default command
CMD ["/bin/bash"]
