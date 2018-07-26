\dontrun{
# See what data is included in the database and for what locations the data is available.
overview <- browseData()
# Hint: If *collapse* FALSE, full version of the overview table
overview <- browseData(collapse = FALSE)

# Available datasets
tables <- browseData(dataset = "DATASETS")

# Available variables for a given dataset
variables <- browseData(dataset = "CLIMATE_LOCAL", variables = TRUE)

# Available locations for a given dataset
available <- browseData(dataset = "CLIMATE_LOCAL")

# Available datasets for a given location
available <- browseData(location ="le_bray")

# Whether a dataset is available for a specific location
available <- browseData(location ="le_bray", dataset = "CLIMATE_LOCAL")

# See version histoy
version <- browseData(dataset = "VERSION")

# Access metadata
metadata <- browseData(dataset = "METADATA_DATASETS")
metadata <- browseData(dataset = "METADATA_CLIMATE_LOCAL")

# Access specific site metadata
metadata <- browseData(dataset = "METADATA_TREE", location = "solling_spruce")

# See data source
source <- browseData(dataset = "SOURCE")

# See specific site data source
source <- browseData(dataset = "SOURCE", location = "solling_spruce")

# See data policy
source <- browseData(dataset = "POLICY")

# See specific site data policy
policy <- browseData(dataset = "POLICY", location = "solling_spruce")
}
