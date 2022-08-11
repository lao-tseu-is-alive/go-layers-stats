<style>
.go-bar-chart {
  width: 100%;
  height: 1000px;
  background-color: white;
}
</style>

<template>
  <div class="w-full">
    <div ref="chartZone" class="go-bar-chart w-full">
      here comes a nice chart
    </div>
  </div>
</template>

<script setup>
const moduleName = "charLayers";
import { onMounted, ref, defineProps } from "vue";
import * as echarts from "echarts";
const props = defineProps({
  data: {
    type: Object,
    required: true,
  },
});

const chartZone = ref(null);
const options = {
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
  series: [ ],
};
onMounted(() => {
  const method = "onMounted";
  console.log(`##-->${moduleName}::${method} data`, props.data);
  const dataLabel = props.data.map((v) => v.layer);
  const dataSeriesRequestGCInternal = {
    name: "requests_gc_internal",
    type: "bar",
    data: props.data.map((v) => v.requests_gc_internal),
  };
  const dataSeriesVisitsGCInternal = {
    name: "visits_gc_internal",
    type: "bar",
    data: props.data.map((v) => v.visits_gc_internal),
  };
  const dataSeriesRequestGCPublic = {
    name: "requests_gc_public",
    type: "bar",
    data: props.data.map((v) => v.requests_gc_public),
  };
  const dataSeriesVisitsGCPublic = {
    name: "visits_gc_public",
    type: "bar",
    data: props.data.map((v) => v.visits_gc_public),
  };

  options.yAxis.data = dataLabel;
  options.series.push(dataSeriesRequestGCInternal);
  options.series.push(dataSeriesVisitsGCInternal);
  options.series.push(dataSeriesRequestGCPublic);
  options.series.push(dataSeriesVisitsGCPublic);
  const myChart = echarts.init(chartZone.value);
  myChart.setOption(options);
});
</script>
