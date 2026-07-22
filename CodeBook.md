# Code Book

## Study and source data

The source is the UCI Human Activity Recognition Using Smartphones dataset. Thirty volunteers aged 19â€“48 performed six activities while wearing a Samsung Galaxy S II smartphone. Its accelerometer and gyroscope signals were sampled at 50 Hz, filtered, divided into fixed-width windows, and used to derive time- and frequency-domain measurements.

Source dataset: <https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Tidy dataset structure

`tidy_data.txt` is a comma-delimited text file with a header row. It has 180 rows and 68 columns. Each row represents exactly one combination of subject and activity. The 66 measurement columns contain group means.

### Identifier variables

| Variable | Type | Values | Description |
|---|---|---|---|
| `subject` | Integer | 1â€“30 | Anonymous participant identifier. |
| `activity` | Character | Six labels listed below | Activity performed during measurement. |

### Activity values

| Value | Description |
|---|---|
| `WALKING` | Walking on a level surface. |
| `WALKING_UPSTAIRS` | Walking upstairs. |
| `WALKING_DOWNSTAIRS` | Walking downstairs. |
| `SITTING` | Sitting. |
| `STANDING` | Standing. |
| `LAYING` | Lying down. |

## Measurement variables

All 66 measurement variables are numeric group means. Values are dimensionless because the source signals were normalized and bounded within `[-1, 1]`. Consequently, their group averages also lie within that interval.

The descriptive names are composed from these elements:

| Name component | Meaning |
|---|---|
| `Time` | Time-domain signal. |
| `Frequency` | Frequency-domain signal produced with a Fast Fourier Transform. |
| `Body` | Body-motion component of acceleration. |
| `Gravity` | Gravity component of acceleration. |
| `Accelerometer` | Signal obtained from the smartphone accelerometer. |
| `Gyroscope` | Signal obtained from the smartphone gyroscope. |
| `Jerk` | Jerk signal derived over time. |
| `Magnitude` | Euclidean magnitude of a three-dimensional signal. |
| `Mean` | Source feature calculated using `mean()`. |
| `StandardDeviation` | Source feature calculated using `std()`. |
| `AxisX`, `AxisY`, `AxisZ` | Measurement axis. |

Examples:

- `TimeBodyAccelerometerMeanAxisX`: mean of the time-domain body-acceleration signal on the X axis.
- `FrequencyBodyGyroscopeStandardDeviationAxisZ`: standard deviation of the frequency-domain body-gyroscope signal on the Z axis.
- `TimeGravityAccelerometerMagnitudeMean`: mean magnitude of the time-domain gravity-acceleration signal.

### Complete measurement inventory

The following compact notation enumerates all measurement columns. For each axis-based signal, both `Mean` and `StandardDeviation` exist for `AxisX`, `AxisY`, and `AxisZ`:

- `TimeBodyAccelerometer{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `TimeGravityAccelerometer{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `TimeBodyAccelerometerJerk{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `TimeBodyGyroscope{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `TimeBodyGyroscopeJerk{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `FrequencyBodyAccelerometer{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `FrequencyBodyAccelerometerJerk{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`
- `FrequencyBodyGyroscope{Mean,StandardDeviation}{AxisX,AxisY,AxisZ}`

For each magnitude signal, both `Mean` and `StandardDeviation` exist:

- `TimeBodyAccelerometerMagnitude{Mean,StandardDeviation}`
- `TimeGravityAccelerometerMagnitude{Mean,StandardDeviation}`
- `TimeBodyAccelerometerJerkMagnitude{Mean,StandardDeviation}`
- `TimeBodyGyroscopeMagnitude{Mean,StandardDeviation}`
- `TimeBodyGyroscopeJerkMagnitude{Mean,StandardDeviation}`
- `FrequencyBodyAccelerometerMagnitude{Mean,StandardDeviation}`
- `FrequencyBodyAccelerometerJerkMagnitude{Mean,StandardDeviation}`
- `FrequencyBodyGyroscopeMagnitude{Mean,StandardDeviation}`
- `FrequencyBodyGyroscopeJerkMagnitude{Mean,StandardDeviation}`

This expands to 48 axis-based variables plus 18 magnitude variables, for 66 measurement variables in total.

## Transformations

1. Training and test observations were appended into one dataset.
2. Subject and activity identifiers were attached to each measurement row.
3. Only the 66 features explicitly containing `-mean()` or `-std()` were retained. `meanFreq()` and angle features were excluded.
4. Numeric activity identifiers were replaced using `activity_labels.txt`.
5. Feature-name abbreviations were expanded as documented above. The duplicated source token `BodyBody` was normalized to `Body`.
6. For every subject-activity combination, the arithmetic mean of each retained measurement was calculated.
7. Rows were ordered by subject and by the activity order provided in the source lookup table.

No missing-value imputation, scaling, or additional signal transformation was performed.
