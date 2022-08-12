<style>
.go-bar-chart {
  width: auto;
  height: 970px;
  background-color: white;
}
</style>

<template>
  <div class="w-full">
    <h3>
      {{ getNumLabels }} couches trouvées
      <template v-if="isFilterPresent">
        , avec le filtre "{{ filterLabel }}"
      </template>
    </h3>

    <div ref="chartZone" class="go-bar-chart w-full">
      a nice chart will soon appear here ...
    </div>
  </div>
</template>

<script setup>
const moduleName = "charLayers";
import { onMounted, ref, defineProps, computed } from "vue";
import * as echarts from "echarts";
import { propertiesToArray, getArrObjectsProperties } from "./dataUtil";
let myChart;

// eslint-disable-next-line prettier/prettier
const extractLabelsAndSeries = function (arrObjects, labelfieldName, filterLabel) {
  const method = "extractLabelsAndSeries";
  console.log(`##-->${moduleName}::${method} `);
  if (arrObjects != undefined) {
    const arrProperties = propertiesToArray(
      arrObjects,
      labelfieldName,
      filterLabel
    );
    // console.log(`##-->${moduleName}::${method} arrProperties`, arrProperties);
    if (arrProperties != null) {
      const series = [];
      getArrObjectsProperties(arrProperties).forEach((field) => {
        if (field == labelfieldName) {
          dataResults.value.labels = arrProperties[field];
        } else {
          series.push({
            name: field,
            type: "bar",
            data: arrProperties[field],
          });
        }
      });
      dataResults.value.series = series;
    }
  }
};

const updateChart = (arrObjects, filterLabel) => {
  const method = "updateChart";
  console.log(`##-->${moduleName}::${method} `);
  if (arrObjects != undefined) {
    extractLabelsAndSeries(arrObjects, "layer", filterLabel);
    chartOptions.value.yAxis.data = dataResults.value.labels;
    chartOptions.value.series = dataResults.value.series;
    if (myChart != undefined || myChart != null) {
      myChart.setOption(chartOptions.value);
    }
  }
};

const props = defineProps({
  filterLabel: {
    type: String,
  },
  dataChart: {
    type: Object,
    required: true,
  },
});
const getNumLabels = computed(() => {
  if (props.dataChart == undefined) {
    return 0;
  } else {
    updateChart(props.dataChart, props.filterLabel);
    return dataResults.value.labels.length;
  }
});

const isFilterPresent = computed(() => {
  if (props.filterLabel !== undefined && props.filterLabel !== null) {
    if (props.filterLabel.trim().length > 0) {
      return true;
    }
  }
  return false;
});

const dataResults = ref({
  labels: [],
  series: [
    {
      name: "no_data_available",
      type: "bar",
      data: [],
    },
  ],
});
const chartZone = ref(null);
const chartOptions = ref({
  title: {
    text: "",
  },
  tooltip: {
    trigger: "axis",
    axisPointer: {
      type: "shadow",
    },
  },
  legend: {},
  grid: {
    left: "3%",
    right: "4%",
    bottom: "3%",
    containLabel: true,
  },
  xAxis: {
    type: "value",
    boundaryGap: [0, 0.01],
  },
  yAxis: {
    type: "category",
    data: [],
  },
  series: [],
});

onMounted(() => {
  const method = "onMounted";
  console.log(`##-->${moduleName}::${method} data`, props.dataChart);
  updateChart(props.dataChart);
  myChart = echarts.init(chartZone.value);
  myChart.setOption(chartOptions.value);
  window.addEventListener('resize', myChart.resize)
});
</script>
