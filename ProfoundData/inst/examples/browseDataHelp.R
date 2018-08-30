\dontrun{
# See available data of the database
overview <- browseData()
# Hint: If *collapse* FALSE, full version of the overview table
overview <- browseData(collapse = FALSE)

# Available datasets
tables <- browseData(dataset = "DATASETS")

# Available variables for a given dataset
variables <- browseData(dataset = "CLIMATE_LOCAL", variables = TRUE)

# Available sites for a given dataset
available <- browseData(dataset = "CLIMATE_LOCAL")

# Available datasets for a given site
available <- browseData(site ="le_bray")

# Whether a dataset is available for a specific site
available <- browseData(site ="le_bray", dataset = "CLIMATE_LOCAL")

# See version history
version <- browseData(dataset = "VERSION")

# See metadata
metadata <- browseData(dataset = "METADATA_DATASETS")
metadata <- browseData(dataset = "METADATA_CLIMATE_LOCAL")

# See metadata of a specific site
metadata <- browseData(dataset = "METADATA_TREE", site = "solling_spruce")

# See data source
source <- browseData(dataset = "SOURCE")

# See data source of a specific site
source <- browseData(dataset = "SOURCE", site = "solling_spruce")

# See data policy
source <- browseData(dataset = "POLICY")

# See data policy of a specific site
policy <- browseData(dataset = "POLICY", site = "solling_spruce")
}
