# 📱 X-Scan 3D
A Polycam-style 3D Scanning App (LiDAR, Photogrammetry & 360° Capture)

Built with SwiftUI, ARKit, RealityKit, and AVFoundation.

---

## 🚀 Overview
X-Scan 3D is a next-generation 3D scanning application for iOS that blends:

* ⚡ **Real-time LiDAR mesh reconstruction**
* 📸 **Local photogrammetry-based 3D capture**
* 🌐 **360° environmental scanning**
* 🗺️ **Explore mode** with map-based scan discovery
* 📁 **In-app library** to preview and manage 3D models

Inspired by Polycam — but designed from the ground up using a modern modular architecture.

**Status:** Early-stage prototype — actively under development.

---

## ✨ Features

### 🔷 1. Capture Modes
* **LiDAR Mode**
    * Real-time point cloud + mesh preview
    * ARKit-based depth capture
* **Photo Mode (Photogrammetry)**
    * High-resolution image capture pipeline
    * Offline reconstruction (coming soon)
* **360° Mode (Coming Soon)**
    * Panorama-style immersive capture

### 🔷 2. Unified Capture HUD
A professional and consistent interface across all modes:

* Top mode selector: `LiDAR` | `Photo` | `360°`
* Torch / Flash support
* Settings & Help buttons
* Glass-style shutter bar
* Quick-access to the 3D library

### 🔷 3. 3D Model Library
Manage all your scans:

* View thumbnails
* Open model detail view
* Organize files for processing and export

### 🔷 4. Explore Map
MapKit-based discoverability:

* Pinch-to-zoom and panning
* Shows locations of your own scans
* Future: Nearby community scans

### 🔷 5. Cross-Platform Architecture
* **SwiftUI** for UI
* **ARKit** for LiDAR
* **AVFoundation** for photo capture
* **SceneKit / RealityKit** for 3D preview
* **Custom `CameraEngine`** for stable switching between LiDAR & Photo

---

## 🔧 Architecture

This diagram shows the modular structure of the app:

```
X-Scan 3D
│
├── CameraEngine.swift          # Unified camera controller (photo mode)
├── ScanView.swift              # ARKit LiDAR scanning view
├── PhotoCaptureView.swift      # AVFoundation camera preview
├── CaptureContainerView.swift  # Polycam-style unified HUD controller
│
├── ModelLibraryView.swift      # List of saved scans
├── ProjectDetailView.swift     # 3D model preview (SceneKit/RealityKit)
├── ExploreMapView.swift        # Map-based scan discovery
│
├── ProjectModel.swift          # Metadata for each scan
├── ProjectViewModel.swift      # App-wide project store
│
└── MainTabView.swift           # Capture | Library | Explore | Profile
```

This design ensures:
* No camera conflicts between `ARKit` & `AVCaptureSession`.
* Clean separation of UI and low-level camera logic.
* Easy future expansion (cloud processing, 360°, segmentation, etc.).

---

## 🛠 Installation

### Requirements
* iOS 16+
* Xcode 15+
* Device with LiDAR scanner recommended:
    * iPhone 12 Pro / 13 Pro / 14 Pro / 15 Pro
    * iPad Pro (2020+)

### Setup
1.  Clone the repo:
    ```bash
    git clone [https://github.com/kotireddys/X-Scan-3D.git](https://github.com/kotireddys/X-Scan-3D.git)
    ```

2.  Open in Xcode:
    ```bash
    open X-Scan-3D/X-Scan-3D.xcodeproj
    ```
3.  Add required permissions to `Info.plist`:

    ```xml
    <key>NSCameraUsageDescription</key>
    <string>This app uses the camera for capturing photos and 3D scans.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Needed for capturing audio during video scans.</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Used to save your captured images and models.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Shows scan locations on the Explore map.</string>
    ```

### Build & Run
Run the app on a real device.

> **❗ Note:** LiDAR scanning is **not** supported in the Simulator.

---

## 📦 Roadmap

### Core Features
* [ ] Offline Photogrammetry (VisionKit / Object Capture)
* [ ] Cloud-based high-quality mesh reconstruction
* [ ] Multi-view Mesh Preview (Textured / Point Cloud / Solid)

### LiDAR Enhancements
* [ ] Real-time mesh coloring
* [ ] Confidence filtering
* [ ] High-density point cloud export

### Photo Mode Enhancements
* [ ] Image series preview
* [ ] Manual camera controls (exposure, focus, ISO)
* [ ] Auto-alignment assistance

### Explore Mode
* [ ] Nearby public scans
* [ ] Leaderboards / featured areas
* [ ] Heatmaps

### Profile / Account
* [ ] Cloud account login
* [S] Syncing models between devices
* [ ] Premium features

---

## 🤝 Contributing
Pull requests are welcome!
Areas where contributions help most:

* UI improvements
* Camera engine optimization
* Photogrammetry pipeline
* LiDAR tracking stability

To contribute:
1.  Fork the project
2.  Create a feature branch
3.  Make your changes
4.  Submit a pull request

---

## 📄 License
This project is licensed under the MIT License.

Feel free to modify and use it for personal or commercial projects.
