var PROVIDERDICTIONARY = {
  csv: {
    provider: 'csv',
  	connectorProvider: 'csv',
  	connectorType: 'document',
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  },
  json: {
    provider: 'json',
  	connectorProvider: 'rwjson',
  	connectorType: 'json',
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  },
  gee: {
    provider: 'gee',
  	connectorProvider: 'gee',
  	connectorType: 'rest',
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  },
  cartodb: {
    provider: 'cartodb',
  	connectorProvider: 'cartodb',
  	connectorType: 'rest',
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  },
  arcgis: {
    provider: 'arcgis',
  	connectorProvider: 'featureservice',
  	connectorType: 'rest',
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  },
  wms: {
    provider: 'wms',
    connectorProvider: null,
  	connectorType: null,
    connectorUrlHint: 'Example: https://wri-01.carto.com/api/v2/sql?q=SELECT%20*%20FROM%20combined01_prepared%20where%20impactparameter=%27Food Demand%27 ."ftjson" param is required in the url'
  }
};
