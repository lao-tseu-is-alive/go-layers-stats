export const APP = 'gc-layers-stats';
export const VERSION = '0.0.2';
export const BUILD_DATE = '2022-08-16';
// eslint-disable-next-line no-undef
export const DEV = process.env.NODE_ENV === 'development';
export const HOME = DEV ? 'http://localhost:5173/html_access/stats/' : '/';
export const DEFAULT_BASE_SERVER_URL = DEV ? 'http://localhost:5173/html_access/stats/' : 'https://carto.lausanne.ch/html_access/stats/';
