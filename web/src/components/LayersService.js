export default class LayersService {
    getLayers() {
        return fetch('/layers_stats.json').then(res => res.json()).then(d => d.data)
    }
}