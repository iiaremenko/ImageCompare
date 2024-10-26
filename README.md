# Image Comparison Tool

## Overview

The Image Comparison Tool is a macOS application designed to compare two images and highlight the differences between them. This tool is particularly useful for developers and testers during screenshot testing, allowing for quick visual verification of changes in UI elements.

## Features

- **Command Line Interface**: Launch the application from the command line with two arguments, each representing the path to the images you want to compare.
- **Screenshot Testing**: Ideal for use in screenshot testing, helping to ensure that visual changes in your application are intentional and correct.
- **Built with SwiftUI**: The application is developed using 100% SwiftUI, providing a modern and responsive user interface.
- **User Observation Framework**: Utilizes the User Observation framework to efficiently track and display changes between images.
- **Two Types of Diff Output**: The application supports two types of difference outputs:
  - **Diff Image**: Displays a new image highlighting the differences between the two compared images.
  - **Slider**: Provides an interactive slider to compare the two images side by side, allowing for a more intuitive visual comparison.

## Usage

To launch the application, open your terminal and run the following command:

```bash
/path/to/ImageComparison /path/to/image1.png /path/to/image2.png
```

Replace `/path/to/ImageComparison` with the actual path to the application and `/path/to/image1.png` and `/path/to/image2.png` with the paths to the images you wish to compare.

## Screenshots

![Screenshot 1](path/to/screenshot1.png)
![Screenshot 2](path/to/screenshot2.png)
![Screenshot 3](path/to/screenshot3.png)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ImageComparisonTool.git
   ```
2. Navigate to the project directory:
   ```bash
   cd ImageComparisonTool
   ```
3. Open the project in Xcode and build the application.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- SwiftUI and the User Observation framework for providing powerful tools for building modern macOS applications.

---

Feel free to customize any sections as needed!