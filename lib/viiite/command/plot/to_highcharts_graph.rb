Alf::Relation[{
  :chart => {
    :renderTo          => 'container',
    :defaultSeriesType => 'line',
    :marginRight       => 170,
    :marginBottom      => 25
  },
  :title => {
    :x => -20
  },
  :yAxis => {
    :title => {
      :text => 'Time (sec.)'
    },
    :plotLines => [{
      :value => 0,
      :width => 1,
      :color => '#808080'
    }]
  },
  :legend => {
    :layout => 'vertical',
    :align  => 'right',
    :verticalAlign => 'top',
    :x => -10,
    :y => 100,
    :borderWidth => 0
  }
}]
