## List of modifications done

```
NCBoost_scripts/prepare_feature_databases.sh
```
In this scripr the path for the NCBoost_features folder was missing for the FuLisD and TajimasD steps.
cd $folder and cd .. added before and after these steps. 

Also standard output has been added to follow the steps proceeding.

```
NCBoost_score.R
```
Complete path for the XGBosst packadge added

```
ncboost_annotate.sh
```
Complete path to python3 and R added


