#!/usr/bin/env python3

import os
import boto3
from tqdm import tqdm
from data_ops import enumerate_data
from data_ops import list_data
from data_ops import get_choice
from data_ops import get_data


def usage():
    """
    """


def get_runs(data):
    """
    """

    data = [sample[:8] for sample in data]
    data = list(set(data))
    if '' in data:
        data.remove('')
    data.sort()

    return data

def get_run_id(run_ids):
    """
    """

    avail_runs = enumerate_data(data = run_ids)

    print("\n" + "#" * 18)
    print("# Available Runs #")
    print("#" * 18 + "\n")
    print("(Index, Run ID)")

    list_data(data = avail_runs)

    run = get_choice(choices = avail_runs)

    return run


def launch_nextflow(bucket, out_dir, run):
    """
    """

    launch = "sudo nextflow run wgs-ufl.nf -work-dir s3://{bucket}/{out_dir}/work/ --bucket 's3://{bucket}' --run_id '{run}'".format(
        bucket = bucket,
        out_dir = out_dir,
        run = run)

    os.system(launch)
    
    trash = "sudo nextflow clean -f"

    os.system(trash)


def archive_fastqs(bucket, processed_dir, samples_dir, run):
    """
    """

    s3 = boto3.resource('s3')
    dest_bucket = s3.Bucket(bucket)

    all_samples = get_data(bucket = bucket, prefix = samples_dir)
    for sample in tqdm(all_samples):
        if run in sample:
            copy_source = {
                'Bucket': bucket,
                'Key': samples_dir + sample
            }
            obj = dest_bucket.Object(samples_dir + processed_dir + sample)
            obj.copy(copy_source)
            src = dest_bucket.Object(samples_dir + sample)
            src.delete()
            print(sample + " archived")



def main():
    """
    """

    bucket = "hakmonkey-genetics-lab"
    out_dir = 'Pipeline_Output/'
    samples_dir = "Fastqs/"
    processed_dir = "Processed/"

    all_samples = get_data(bucket = bucket, prefix = samples_dir)

    all_run_ids = get_runs(data = all_samples)

    run = get_run_id(run_ids = all_run_ids)

    launch_nextflow(
        bucket = bucket,
        out_dir = out_dir.strip('/'),
        run = run
    )

    archive_fastqs(
        bucket = bucket,
        processed_dir = processed_dir,
        samples_dir = samples_dir,
        run = run)


if __name__ == '__main__':
    main()