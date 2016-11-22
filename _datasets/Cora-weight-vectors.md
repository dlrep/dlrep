---
date: 2016-11-21
title: Cora weight vectors
proposer: Peter Christen 
tags:
- bibliographic
- local
- public
- similarity
---

## Description

This data set is a file containing vectors with weights (similarities) as calculated between attributes of the
[Cora](../Cora.html) data set.

## Files

[cora-weight-vectors.csv.gz](cora-weight-vectors.csv.gz)

The header line of this file contains the following attributes/fields:

```
rec_id1,rec_id2,Str-Exact-ID-ID,Q-Gram-AUTHORS-AUTHORS,Q-Gram-TITLE-TITLE,Q-Gram-VENUE-VENUE,Edit-Dist-YEAR-YEAR
```

with elements:
- rec_id1, rec_id2: The two (internal to Febrl, see below) record identifiers.

- Str-Exact-ID-ID: If this value is 1.0 it means the corresponding two records refer to the same publication
  (a truematch), if it is 0.0 it corresponds to a non-match.

- Q-Gram-AUTHORS-AUTHORS,Q-Gram-TITLE-TITLE,Q-Gram-VENUE-VENUE,Edit-Dist-YEAR-YEAR: These are the similarity
  values calculated when the corresponding attribute values were compared (for details see the Febrl project
   code below).

This weight vector file was generated using the [Febrl](https://sourceforge.net/projects/febrl/) (Freely Extensible
Biomedical Record Linkage) system. The Python script used is:

[febrl-cora-project.py](febrl-cora-project.py)

## Citation

```
@inproceedings{christen2015efficient,
  title={Efficient Entity Resolution with Adaptive and Interactive Training Data Selection},
  author={Christen, Peter and Vatsalan, Dinusha and Wang, Qing},
  booktitle={Data Mining (ICDM), 2015 IEEE International Conference on},
  pages={727--732},
  year={2015},
  organization={IEEE}
}
```

## References

[Efficient Entity Resolution with Adaptive and Interactive Training Data Selection, P Christen, D Vatsalan
and Q Wang, 2015](http://ieeexplore.ieee.org/document/7373380/)

[Efficient Interactive Training Selection for Large-Scale Entity Resolution, Q Wang, D Vatsalan and P
Christen, 2015](http://link.springer.com/chapter/10.1007/978-3-319-18032-8_44)
