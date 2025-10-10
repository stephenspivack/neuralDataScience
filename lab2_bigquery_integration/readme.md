# 🧠 Neural Data Science — BigQuery Access Setup (Fall 2025)

This guide walks you through everything you need to access the BigQuery datasets for this course using your NYU account — from scratch.

---

## 🧠 What Is the Google Cloud SDK?

The **Google Cloud SDK** is a set of command-line tools that let you interact with Google Cloud products like BigQuery.

It includes:
- `gcloud`: Main tool for authentication and project access

We’ll use it to run:
```bash
gcloud auth application-default login
```
This logs you into your NYU Google account and makes your Python code BigQuery-ready.

---

## ✅ Step 1: Install the Google Cloud SDK

### 🔗 Official Docs: https://cloud.google.com/sdk/docs/install

---

### 💻 For macOS (Apple Silicon or Intel):

1. Open Terminal
2. Download the SDK:
    - For Apple Silicon (M1/M2):
      ```bash
      curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-456.0.0-darwin-arm.tar.gz
      ```
    - For Intel Macs:
      ```bash
      curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-456.0.0-darwin-x86_64.tar.gz
      ```

3. Extract and install:
    ```bash
    tar -xvzf google-cloud-sdk-*.tar.gz
    ./google-cloud-sdk/install.sh
    ```

4. Restart your terminal

---

### 🪟 For Windows:

1. Download the installer:  
   👉 https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe

2. Run the installer and follow the prompts
3. Accept defaults and complete the install

---

## ✅ Step 2: Authenticate Using Your NYU Account

Once the SDK is installed, run:
```bash
gcloud auth application-default login
```

- A browser window will open
- Log in using your **NYU email (e.g., netid@nyu.edu)**
- This stores credentials locally so Python can access BigQuery

---

## ✅ Step 3: Install Python Packages

Open Terminal and run:

```bash
pip install db-dtypes google-cloud-bigquery pandas numpy matplotlib notebook ipython
```

---

## ✅ Step 4: Launch Jupyter and Query BigQuery

Start Jupyter:
```bash
jupyter notebook
```

Then paste this in a notebook cell:

```python
from google.cloud import bigquery
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

client = bigquery.Client(project="neural-ds-fe73", client_options={"api_endpoint": "https://bigquery.googleapis.com"})

query = '''
  select
    trial_id,
    (select array_agg(cast(x as float64)) from unnest(json_extract_array(spike_times)) as x) as spike_times,
    condition_id,
    condition_angle,
    unit_label
  from neural-ds-fe73.lab1_ephys.mt
'''

df = client.query(query).to_dataframe()
df.head()
```

---

## 🛡️ Security & Credentials

- You do **not** need to manually copy any API keys or JSON files
- Authentication is handled securely using your NYU account
- You can revoke access at: https://myaccount.google.com/permissions

---

## ❗ Troubleshooting

| Problem                        | Fix                                                  |
|-------------------------------|-------------------------------------------------------|
| `403 Permission Denied`       | Make sure you logged in with your **NYU email**      |
| `bigquery.Client()` fails     | Run `gcloud auth application-default login` again     |
| Import errors                 | Re-run `pip install` as shown above                  |

---
